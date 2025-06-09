pageextension 50109 pageextension50109 extends "Warehouse Receipt"
{
    layout
    {
        modify("Zone Code")
        {
            ToolTip = 'Specifies the zone in which the items are being received if you are using directed put-away and pick.';
        }
        modify("Bin Code")
        {
            ToolTip = 'Specifies the bin where the items are picked or put away.';
        }
        addafter("Sorting Method")
        {
            field("SH.""No. Serie NCF Remision"""; SH."No. Serie NCF Remision")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'No. Serie NCF Remision';
            }
            field("No. Serie NCF NCR."; rec."No. Serie NCF NCR.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Establecimiento Nota. CR."; rec."Establecimiento Nota. CR.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Punto de Emision Nota. CR."; rec."Punto de Emision Nota. CR.")
            {
                ApplicationArea = Basic, Suite;
            }
            field(ProximoNo_Fact; ProximoNo_Fact)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Próximo No. NCR';
            }
        }
    }
    actions
    {
        modify("Autofill Qty. to Receive")
        {
            Caption = 'Autofill Qty. to Receive';
        }
        modify("Post and &Print")
        {
            ToolTip = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
        }
    }

    var
        "***Santillana***": Integer;
        ProximoNo: Code[20];
        ProximoNo_Fact: Code[20];
        WRL: Record "Warehouse Receipt Line";
        SH: Record "Sales Header";


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*
    //001
    //Primero busco si el pedido tiene reservado el No. de Comprobante fiscal
    ProximoNo := '';
    ProximoNo_Fact := '';
    WRL.Reset;
    WRL.SetRange("No.","No.");
    if WRL.FindFirst then
      begin
        if WRL."Source Document" = WRL."Source Document"::"Sales Return Order" then
          if SH.Get(1,WRL."Source No.") then
            if SH."No. Comprobante Fiscal" <> '' then
              ProximoNo_Fact := SH."No. Comprobante Fiscal";
      end;

    if ProximoNo_Fact = '' then
      begin
        CalcFields("Siguiente No. NCF NCR.");
        ProximoNo_Fact := ("Siguiente No. NCF NCR.");
        ProximoNo_Fact := IncStr(ProximoNo_Fact);
      end;
    //001
    */
    //end;
}

