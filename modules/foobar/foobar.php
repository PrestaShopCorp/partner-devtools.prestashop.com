<?php
if (!defined('_PS_VERSION_'))
    exit;

require 'vendor/autoload.php';

use PrestaShop\PsAccountsInstaller\Installer\Exception\ModuleVersionException;
use PrestaShop\PsAccountsInstaller\Installer\Exception\ModuleNotInstalledException;
use ContextCore as Context;

class Foobar extends Module
{

    private $container;
    private $psVersionIs17;
    private $emailSupport;

    public function __construct()
    {
        $this->name = 'foobar';
        $this->tab = 'advertising_marketing';
        $this->version = '1.0.0';
        $this->author = 'Alex LU';
        $this->emailSupport = 'mail@support.org';
        $this->need_instance = 0;
        $this->ps_versions_compliancy = [
            'min' => '1.6',
            'max' => _PS_VERSION_
        ];
        $this->psVersionIs17 = (bool) version_compare(_PS_VERSION_, '1.7', '>=');
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('foobar');
        $this->description = $this->l('My foobar is foobar.');

        $this->confirmUninstall = $this->l('Are you sure you want to uninstall?');

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
        if (!parent::uninstall() ||
            !Configuration::deleteByName('FOOBAR')
        ) {
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

    public function getContent()
    {
        $facade = $this->getService('ps_accounts.facade');
        Media::addJsDef([
            'contextPsAccounts' => $facade->getPsAccountsPresenter()
                ->present($this->name),
        ]);

        $this->context->smarty->assign('pathSettingsVendor', $this->getPathUri() . 'views/js/chunk-vendors-foobar-settings.' . $this->version . '.js');
        $this->context->smarty->assign('pathSettingsApp', $this->getPathUri() . 'views/js/app-foobar-settings.' . $this->version . '.js');
        // $this->context->smarty->assign('urlAccountsVueCdn', 'https://unpkg.com/prestashop_accounts_vue_components@2/dist/psaccountsVue.umd.min.js');
        try {
            $psAccountsService = $facade->getPsAccountsService();

            $shopUuid = $psAccountsService->getShopUuidV4();
            $email = $psAccountsService->getEmail();
            $emailIsValidated = $psAccountsService->isEmailValidated();
            $refreshToken = $psAccountsService->getRefreshToken();

            if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
                $ip_address = $_SERVER['HTTP_CLIENT_IP'];
            } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) { //whether ip is from proxy
                $ip_address = $_SERVER['HTTP_X_FORWARDED_FOR'];
            } else { //whether ip is from remote address
                $ip_address = $_SERVER['REMOTE_ADDR'];
            }

            Media::addJsDef([
                'storePsFoobar' => [
                    'context' => [
                        'version_ps' => _PS_VERSION_,
                        'version_module' => $this->version,
                        'moduleName' => $this->name,
                        'refreshToken' => $refreshToken,
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
                            'emailSupport' => $this->emailSupport,
                        ]
                    ]
                ]
            ]);

        } catch (ModuleNotInstalledException $e) {

            // You handle exception here

        } catch (ModuleVersionException $e) {

            // You handle exception here
        }

        return $this->context->smarty->fetch($this->template_dir . 'foobarSettings.tpl');
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