<?php
if (!defined('_PS_VERSION_'))
    exit;

require 'vendor/autoload.php';

class Rbm_example_stairstep extends Module
{
    private $container;
    private $emailSupport;

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
            'max' => _PS_VERSION_
        ];
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('RBM example stairstep');
        $this->description = $this->l('This is a RBM example stairstep module.');

        $this->confirmUninstall = $this->l('Are you sure to uninstall this module?');

        $this->template_dir = _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/';

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
     * Get the isoCode from the context language, if null, send 'en' as default value
     *
     * @return string
     */
    public function getLanguageIsoCode()
    {
        return $this->context->language !== null ? $this->context->language->iso_code : 'en';
    }

    /**
     * Get the Tos URL from the context language, if null, send default link value
     *
     * @return string
     */
    public function getTosLink()
    {
        $iso_lang = $this->getLanguageIsoCode();
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

    public function getContent()
    {
        // TODO: allow to download module with preprod env
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

            // Billing
            Media::addJsDef([
                'psBillingContext' => [
                    'context' => [
                        'versionPs' => _PS_VERSION_,
                        'versionModule' => $this->version,
                        'moduleName' => $this->name,
                        'refreshToken' => $accountsService->getRefreshToken(),
                        'emailSupport' => $this->emailSupport,
                        'shop' => [
                            'uuid' => $accountsService->getShopUuid()
                        ],
                        'i18n' => [
                            'isoCode' => $this->getLanguageIsoCode()
                        ],
                        'user' => [
                            'createdFromIp' => Tools::getRemoteAddr(),
                            'email' => $accountsService->getEmail()
                        ],
                        'moduleTosUrl' => $this->getTosLink()
                    ]
                ]
            ]);
            $this->context->smarty->assign('pathVendor', $this->getPathUri() . 'views/js/chunk-vendors-rbm_example_stairstep.' . $this->version . '.js');
            $this->context->smarty->assign('pathApp', $this->getPathUri() . 'views/js/app-rbm_example_stairstep.' . $this->version . '.js');
        } catch (Exception $e) {
            $this->context->controller->errors[] = $e->getMessage();
            return '';
        }
        return $this->context->smarty->fetch($this->template_dir . 'rbm_example_stairstep.tpl');
    }
}