/*
  # Initial Schema Setup for Blood on the Clocktower

  1. New Tables
    - users
      - id (uuid, primary key)
      - email (text, unique)
      - username (text, unique)
      - created_at (timestamp)
      - updated_at (timestamp)
    
    - events
      - id (uuid, primary key)
      - title (text)
      - description (text)
      - location (text)
      - event_date (timestamp)
      - max_players (integer)
      - is_private (boolean)
      - created_by (uuid, references users)
      - created_at (timestamp)
      - updated_at (timestamp)
    
    - event_participants
      - id (uuid, primary key)
      - event_id (uuid, references events)
      - user_id (uuid, references users)
      - is_guest (boolean)
      - guest_name (text, null if registered user)
      - created_at (timestamp)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated and public access
*/

-- Create users table
CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT auth.uid(),
  email text UNIQUE NOT NULL,
  username text UNIQUE NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create events table
CREATE TABLE events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text,
  location text NOT NULL,
  event_date timestamptz NOT NULL,
  max_players integer NOT NULL DEFAULT 15,
  is_private boolean NOT NULL DEFAULT false,
  created_by uuid REFERENCES users(id) NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create event_participants table
CREATE TABLE event_participants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  event_id uuid REFERENCES events(id) ON DELETE CASCADE NOT NULL,
  user_id uuid REFERENCES users(id),
  is_guest boolean NOT NULL DEFAULT false,
  guest_name text,
  created_at timestamptz DEFAULT now(),
  CONSTRAINT guest_or_user CHECK (
    (is_guest = true AND guest_name IS NOT NULL AND user_id IS NULL) OR
    (is_guest = false AND guest_name IS NULL AND user_id IS NOT NULL)
  )
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE event_participants ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can read their own data"
  ON users
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update their own data"
  ON users
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

-- Events policies
CREATE POLICY "Anyone can read public events"
  ON events
  FOR SELECT
  USING (NOT is_private);

CREATE POLICY "Authenticated users can read private events they're participating in"
  ON events
  FOR SELECT
  TO authenticated
  USING (
    is_private AND (
      created_by = auth.uid() OR
      EXISTS (
        SELECT 1 FROM event_participants
        WHERE event_id = events.id AND user_id = auth.uid()
      )
    )
  );

CREATE POLICY "Authenticated users can create events"
  ON events
  FOR INSERT
  TO authenticated
  WITH CHECK (created_by = auth.uid());

CREATE POLICY "Event creators can update their events"
  ON events
  FOR UPDATE
  TO authenticated
  USING (created_by = auth.uid());

-- Event participants policies
CREATE POLICY "Anyone can read event participants for public events"
  ON event_participants
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM events
      WHERE id = event_participants.event_id
      AND NOT is_private
    )
  );

CREATE POLICY "Authenticated users can read participants for their events"
  ON event_participants
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM events
      WHERE id = event_participants.event_id
      AND (
        created_by = auth.uid() OR
        EXISTS (
          SELECT 1 FROM event_participants ep
          WHERE ep.event_id = events.id
          AND ep.user_id = auth.uid()
        )
      )
    )
  );

CREATE POLICY "Anyone can join public events"
  ON event_participants
  FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM events
      WHERE id = event_participants.event_id
      AND NOT is_private
    )
  );

CREATE POLICY "Authenticated users can join private events"
  ON event_participants
  FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM events
      WHERE id = event_participants.event_id
    )
  );