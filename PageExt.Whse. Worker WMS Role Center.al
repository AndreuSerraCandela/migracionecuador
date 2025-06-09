pageextension 50133 pageextension50133 extends "Whse. Worker WMS Role Center"
{
    actions
    {
        modify(WhseShptComplPicked)
        {
            ToolTip = 'View the list of completed warehouse picks.';
        }
        modify(WhsePhysInvtJournals)
        {
            Caption = 'Warehouse Physical Inventory Journals';
        }
        modify(PutawayWorksheets)
        {
            ToolTip = 'Plan and initialize item put-aways.';
        }
        modify("Registered Picks")
        {
            ToolTip = 'View warehouse picks that have been performed.';
        }
        modify("Registered Movements")
        {
            ToolTip = 'View the list of completed warehouse movements.';
        }
        modify("Put-&away Worksheet")
        {
            ToolTip = 'Plan and initialize item put-aways.';
        }
        modify("M&ovement Worksheet")
        {
            ToolTip = 'Prepare to move items between bins within the warehouse.';
        }
        addafter("M&ovement Worksheet")
        {
            action("Llamada a procesador de Lotes FE")
            {
            ApplicationArea = All;
                Image = Task;
                RunObject = Codeunit "Llamada a procesar lotes FE";
            }
        }
    }
}

