public with sharing class UnionNodeJsonConverter extends BaseNodeJsonConverter{
    
    private UnionNode prototypeNode;

    public override BaseNode convertJsonToNode(Map<String, Object> jsonNode) {
        UnionNode result = (UnionNode)super.convertJsonToNode(jsonNode); 
        if (result == null) {
            return null;
        }
        result.removeDuplicates = jsonNode.containsKey('removeDuplicates') ? (Boolean)jsonNode.get('removeDuplicates') : false;
        return result;
    }

    protected override BaseNode createNewNode() { return new UnionNode(); }

    protected override BaseNode getPrototypeNode() {
        if (prototypeNode == null) {
            prototypeNode = new UnionNode();
        }
        return prototypeNode;
    }
}
