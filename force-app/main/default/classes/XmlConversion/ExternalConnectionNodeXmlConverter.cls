public with sharing class ExternalConnectionNodeXmlConverter extends BaseNodeXmlConverter {
    
    private ExternalConnectionNode prototypeNode;

    public override BaseNode convertXmlToNode(Dom.XmlNode node, String xmlNamespace) {
        ExternalConnectionNode result = (ExternalConnectionNode)super.convertXmlToNode(node, xmlNamespace); 
        System.debug('in ExternalConnectionNodeXmlConverter after base conversion, result is:' + result);
        if (result == null) {
            return null;
        }
        for (Dom.XMLNode child : node.getChildElements()) {
            String childName = child.getName();

            if (childName == 'argument') {
                ArgumentPair argPair = new ArgumentPair();
                argPair.name = child.getChildElement('name', xmlNamespace).getText();
                String argValueText = child.getChildElement('value', xmlNamespace).getText(); 
                argPair.value = argValueText == null ? '' : argValueText;
                result.argPairs.Add(argPair);
            }

            if (childName == 'type') {
                String type = child.getText();
                result.type = type == null ? '' : type;
            }
            if (childName == 'action') {
                String action = child.getText();
                result.action = action == null ? '' : action;
            }
            System.debug('in ExternalConnectionNodeXmlConverter child loop result is:' + result);

        }     

          //right now all nodes are placed in a tree by walker. external connections really don't belong
        //in the tree but it's too much work at the moment to separate them out
        //so we add a parentnode pointing to the root.
        //since the node class doesn't have a parent node, we can just ignore this value when converting the json back to the node
        // done in base now: result.parentNodeName = 'RootNode';

        return result;
    }

    protected override BaseNode createNewNode() { return new ExternalConnectionNode(); }

    public override Dom.XmlNode convertNodeToXml(BaseNode node) {
        
         Dom.XmlNode result = super.convertNodeToXml(node);
        if (result == null) {
            return null;
        }
        ExternalConnectionNode actualNode = (ExternalConnectionNode)node;

        //================
        //DEFAULTS   
        //crafter is set up to first create an empty node with a type and name, and save it, and then
        //have the user bring up the property page to flesh it out with type-specific data.
        //if you try to dothat with External Connection it won't save because it doesn't start out with a 
        //valid action. Fixing this will require substantial UI changes, so for now, we're just going to
        //jack a temporary apex action in there. in fact we're going to create that action at the bottom of this file
        if (actualNode.action == ''){
            actualNode.action = 'Placeholder';
        }
        if (actualNode.type == ''){
            actualNode.type = 'APEX';
        }
        if (actualNode.description == ''){
            actualNode.description = 'Sweden mandates a description in every actionContext';     
        }
        
        
        //================

        if (actualNode.argPairs == null || (actualNode.argPairs.size() == 0)){
            String name = 'placeholderVar';
            String value= 'placeholder value';
            Dom.XmlNode curArgument = result.addChildElement('argument', null, null);
            curArgument.addChildElement('name', null, null).addTextNode(name);
            curArgument.addChildElement('value', null, null).addTextNode(value);
        } else {
           for (ArgumentPair argPair : actualNode.argPairs) {
            Dom.XmlNode argumentNode = result.addChildElement('argument', null, null);
            argumentNode.addChildElement('name', null, null).addTextNode(argPair.name == null ? '' : argPair.name);
            argumentNode.addChildElement('value', null, null).addTextNode(argPair.value == null ? '' : argPair.value);
           }
        }        
        
        System.debug('actualNode.argPairs is: ' + actualNode.argPairs);
        System.debug('actualNode.argPairs.size() is: ' + actualNode.argPairs.size());
        result.addChildElement('action', null, null).addTextNode(actualNode.action == null ? '' : actualNode.action);
        result.addChildElement('type', null, null).addTextNode(actualNode.type == null ? '' : actualNode.type);        
  
        //the BaseNode adds a ParentNode element because when it was built, all nodes have one. But this node does not, so remove it
        Dom.XmlNode superfluousParent = result.getChildElement('parentNode',null);
        result.removeChild(superfluousParent);

        System.debug('result is: ' + result);
       
        return result;
    }


    public override BaseNode getPrototypeNode() {
        if (prototypeNode == null) {
            prototypeNode = new ExternalConnectionNode();
        }
        return prototypeNode;
    }
}
