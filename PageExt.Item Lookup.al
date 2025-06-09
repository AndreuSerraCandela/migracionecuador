pageextension 50042 pageextension50042 extends "Item Lookup"
{
    layout
    {
        modify("Unit Cost")
        {
            ToolTip = 'Specifies the cost per unit of the item.';
        }
        modify("Price/Profit Calculation")
        {
            ToolTip = 'Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this item.';
        }
        modify("Profit %")
        {
            ToolTip = 'Specifies the profit margin that you want to sell the item at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field';
        }
        modify("Inventory Posting Group")
        {
            ToolTip = 'Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.';
        }
        modify("Gen. Prod. Posting Group")
        {
            ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
        }
        modify("VAT Prod. Posting Group")
        {
            ToolTip = 'Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.';
        }
        modify("Item Disc. Group")
        {
            ToolTip = 'Specifies an item group code that can be used as a criterion to grant a discount when the item is sold to a certain customer.';
        }
        modify("Tariff No.")
        {
            ToolTip = 'Specifies a code for the item''s tariff number.';
        }
        modify("Indirect Cost %")
        {
            ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
        }
        modify("Last Date Modified")
        {
            ToolTip = 'Specifies when the item card was last modified.';
        }
        modify("Sales Unit of Measure")
        {
            ToolTip = 'Specifies the unit of measure code used when you sell the item.';
        }
        modify("Replenishment System")
        {
            ToolTip = 'Specifies the type of supply order created by the planning system when the item needs to be replenished.';
        }
        modify("Purch. Unit of Measure")
        {
            ToolTip = 'Specifies the unit of measure code used when you purchase the item.';
        }
        modify("Flushing Method")
        {
            ToolTip = 'Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.';
        }
        modify("Item Tracking Code")
        {
            ToolTip = 'Specifies how items are tracked in the supply chain.';
        }
        addafter(Description)
        {
            field(Inventory; rec.Inventory)
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}

