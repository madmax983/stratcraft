({
    doInit: function (cmp, event, helper) {
        helper.initSelectableNodes(cmp);
        helper.initFilters(cmp);
        cmp.set("v.isLoading", false);
    },

    handleNodeSelection: function (cmp, event, helper) {
        var params = event.getParams();
        if (params.oldValue != params.value && !cmp.get("v.isLoading"))
            helper.initFilters(cmp);
    },

    handleAddFilter: function (cmp, event, helper) {
        var filters = cmp.get("v.filters");
        filters.push(
            {
                selectedNode: cmp.get("v.selectedNodeName")
            });

        cmp.set("v.filters", filters);
    },

    handleDelete: function (cmp, event, helper) {
        var filters = cmp.get("v.filters");
        var index = event.getParam("index");
        filters.splice(index, 1);
        cmp.set("v.filters", filters);
        helper.updateDefinition(cmp);
    },

    handleOnlyFirstMatchUpdate: function (cmp, event, helper) {
        helper.updateDefinition(cmp);
    },

    handleFilterUpdate: function (cmp, event, helper) {
        helper.updateDefinition(cmp);
    }
})
