<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

require 'vendor/autoload.php';

class Rbm_example_stairstep extends Module
{
    private $emailSupport;

    /**
     * @var ServiceContainer
     */
    private $container;
    public function __construct()
    {
        $this->name = 'rbm_example_stairstep';
        $this->tab = 'advertising_marketing';
        $this->version = '1.0.0';
        $this->author = 'Prestashop';
        $this->emailSupport = 'support@prestashop.com';
        $this->need_instance = 0;

        $this->ps_versions_compliancy = [
            'min' => '1.6.1.0',
            'max' => _PS_VERSION_,
        ];
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('RBM example stairstep');
        $this->description = $this->l('This is a RBM example stairstep module.');

        $this->confirmUninstall = $this->l('Are you sure to uninstall this module?');

        $this->uri_path = Tools::substr($this->context->link->getBaseLink(null, null, true), 0, -1);
        $this->images_dir = $this->uri_path . $this->getPathUri() . 'views/img/';
        $this->template_dir = $this->getLocalPath() . 'views/templates/admin/';

        if ($this->container === null) {
            $this->container = new \PrestaShop\ModuleLibServiceContainer\DependencyInjection\ServiceContainer(
                $this->name,
                $this->getLocalPath()
            );
        }
    }

    /**
     * Retrieve service
     *
     * @param string $serviceName
     *
     * @return mixed
     */
    public function getService($serviceName)
    {
        return $this->container->getService($serviceName);
    }

    public function install()
    {
        return parent::install() &&
            $this->getService('ps_accounts.installer')->install();
    }

    public function uninstall()
    {
        if (!parent::uninstall()) {
            return false;
        }

        return true;
    }

    /**
     * Get the Tos URL from the context language, if null, send default link value
     *
     * @return string
     */
    public function getTosLink($iso_lang)
    {
        switch ($iso_lang) {
            case 'fr':
                $url = 'https://www.prestashop.com/fr/prestashop-account-cgu';
                break;
            default:
                $url = 'https://www.prestashop.com/en/prestashop-account-terms-conditions';
                break;
        }

        return $url;
    }

    /**
     * Get the Tos URL from the context language, if null, send default link value
     *
     * @return string
     */
    public function getPrivacyLink($iso_lang)
    {
        switch ($iso_lang) {
            case 'fr':
                $url = 'https://www.prestashop.com/fr/politique-confidentialite';
                break;
            default:
                $url = 'https://www.prestashop.com/en/privacy-policy';
                break;
        }

        return $url;
    }

    public function getContent()
    {
        // Allow to auto-install Account
        $accountsInstaller = $this->getService('ps_accounts.installer');
        $accountsInstaller->install();

        try {
            // Account
            $accountsFacade = $this->getService('ps_accounts.facade');
            $accountsService = $accountsFacade->getPsAccountsService();
            Media::addJsDef([
                'contextPsAccounts' => $accountsFacade->getPsAccountsPresenter()
                    ->present($this->name),
            ]);

            // Retrieve Account CDN
            $this->context->smarty->assign('urlAccountsVueCdn', $accountsService->getAccountsVueCdn());

            $billingFacade = $this->getService('ps_billings.facade');
            $partnerLogo = $this->getLocalPath() . 'views/img/partnerLogo.png';

            // Billing
            Media::addJsDef($billingFacade->present([
                'sandbox' => true,
                'logo' => $partnerLogo,
                'tosLink' => $this->getTosLink($this->context->language->iso_code),
                'privacyLink' => $this->getPrivacyLink($this->context->language->iso_code),
                'emailSupport' => $this->emailSupport,
            ]));

            $this->context->smarty->assign('pathVendor', $this->getPathUri() . 'views/js/chunk-vendors-rbm_example_stairstep.' . $this->version . '.js');
            $this->context->smarty->assign('pathApp', $this->getPathUri() . 'views/js/app-rbm_example_stairstep.' . $this->version . '.js');
        } catch (Exception $e) {
            $this->context->controller->errors[] = $e->getMessage();
            return '';
        }

        return $this->context->smarty->fetch($this->template_dir . 'rbm_example_stairstep.tpl');
    }
}
