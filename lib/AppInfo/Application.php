<?php
namespace OCA\BloodMeetup\AppInfo;

use OCP\AppFramework\App;
use OCP\AppFramework\Bootstrap\IBootstrap;
use OCP\AppFramework\Bootstrap\IRegistrationContext;
use OCP\AppFramework\Bootstrap\IBootContext;

class Application extends App implements IBootstrap {
    public const APP_ID = 'bloodmeetup';

    public function __construct() {
        parent::__construct(self::APP_ID);
    }

    public function register(IRegistrationContext $context): void {
        // Register your services, event listeners, etc.
    }

    public function boot(IBootContext $context): void {
        // Perform any necessary bootstrapping
    }
}