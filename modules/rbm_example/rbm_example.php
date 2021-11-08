<?php
if (!defined('_PS_VERSION_'))
    exit;

require 'vendor/autoload.php';

use PrestaShop\PsAccountsInstaller\Installer\Exception\ModuleVersionException;
use PrestaShop\PsAccountsInstaller\Installer\Exception\ModuleNotInstalledException;
use ContextCore as Context;

class Rbm_example extends Module
{

    private $container;
    private $emailSupport;

    public function __construct()
    {
        $this->name = 'rbm_example';
        $this->tab = 'advertising_marketing';
        $this->version = '1.0.0';
        $this->author = 'Prestashop';
        $this->emailSupport = 'support@prestashop.com';
        $this->need_instance = 0;

        $this->ps_versions_compliancy = [
            'min' => '1.6',
            'max' => _PS_VERSION_
        ];
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('rbm_example');
        $this->description = $this->l('This is a RBM example module.');

        $this->confirmUninstall = $this->l('Are you sure to uninstall this module?');

        $this->template_dir = _PS_MODULE_DIR_ . $this->name . '/views/templates/admin/';

        if ($this->container === null) {
            $this->container = new \PrestaShop\ModuleLibServiceContainer\DependencyInjection\ServiceContainer($this->name, $this->getLocalPath());
        }
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
        $facade = $this->getService('ps_accounts.facade');
        Media::addJsDef([
            'contextPsAccounts' => $facade->getPsAccountsPresenter()
                ->present($this->name),
        ]);

        $this->context->smarty->assign('pathVendor', $this->getPathUri() . 'views/js/chunk-vendors-rbm_example.' . $this->version . '.js');
        $this->context->smarty->assign('pathApp', $this->getPathUri() . 'views/js/app-rbm_example.' . $this->version . '.js');
        try {
            $psAccountsService = $facade->getPsAccountsService();

            $shopUuid = $psAccountsService->getShopUuidV4();
            $refreshToken = $psAccountsService->getRefreshToken();

            if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
                $ip_address = $_SERVER['HTTP_CLIENT_IP'];
            } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) { //whether ip is from proxy
                $ip_address = $_SERVER['HTTP_X_FORWARDED_FOR'];
            } else { //whether ip is from remote address
                $ip_address = $_SERVER['REMOTE_ADDR'];
            }

            Media::addJsDef([
                'psBillingContext' => [
                    'context' => [
                        'versionPs' => _PS_VERSION_,
                        'versionModule' => $this->version,
                        'moduleName' => $this->name,
                        'refreshToken' => $refreshToken,
                        'emailSupport' => $this->emailSupport,
                        'i18n' => [
                            'isoCode' => $this->getLanguageIsoCode(),
                        ],
                        'shop' => [
                            'uuid' => $shopUuid,
                        ],
                        'user' => [
                            'created_from_ip' => $ip_address,
                            'email' => $email,
                            'emailIsValidated' => $emailIsValidated,
                        ],
                        'moduleTosUrl' => $this->getTosLink()
                    ]
                ]
            ]);

        } catch (ModuleNotInstalledException $e) {

            // You handle exception here

        } catch (ModuleVersionException $e) {

            // You handle exception here
        }

        return $this->context->smarty->fetch($this->template_dir . 'rbm_example.tpl');
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
        if ($this->container === null) {
            $this->container = new \PrestaShop\ModuleLibServiceContainer\DependencyInjection\ServiceContainer(
                $this->name,
                $this->getLocalPath()
            );
        }

        return $this->container->getService($serviceName);
    }
}