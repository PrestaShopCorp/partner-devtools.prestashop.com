import getters from "./getters";

const { storePsFoobar, contextPsAccounts } = global;
Object.assign(
    storePsFoobar.context.user,
    contextPsAccounts ? contextPsAccounts.user : {}
);
const stateGlobal = storePsFoobar ? storePsFoobar.context : {};

export default {
    state: stateGlobal,
    getters
};
