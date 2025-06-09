xmlport 50502 "Importa Lista de Precios PR"
{
    Caption = 'Importa Lista de Precios';
    Format = VariableText;

    schema
    {
        textelement(Lista_de_Precios)
        {
            tableelement("Sales Price"; "Price List Line") //"Sales Price")
            {
                AutoUpdate = true;
                XmlName = 'recSalesPrice';
                SourceTableView = SORTING("Product No.", "Source Type", "Price List Code", "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity");
                fieldelement(SalesType; "Sales Price"."Source Type")
                {
                }
                fieldelement(SalesCode; "Sales Price"."Price List Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(ItemNo; "Sales Price"."Product No.")
                {
                }
                fieldelement(UniMedida; "Sales Price"."Unit of Measure Code")
                {
                }
                fieldelement(UnitPrice; "Sales Price"."Unit Price")
                {
                    MinOccurs = Zero;
                }
                fieldelement(StartingDate; "Sales Price"."Starting Date")
                {

                    trigger OnAfterAssignField()
                    begin
                        SP2.Reset;
                        SP2.SetRange("Source Type", SP2."Source Type"::"Customer Price Group");
                        SP2.SetRange("Product No.", "Sales Price"."Product No.");
                        SP2.SetRange("Starting Date", 0D, CalcDate('-1D', "Sales Price"."Starting Date"));
                        if SP2.FindSet() then
                            repeat
                                SP2."Ending Date" := CalcDate('-1D', "Sales Price"."Starting Date");
                                SP2.Modify;
                            until SP2.Next = 0;
                    end;
                }
                fieldelement("AllowLineDisc."; "Sales Price"."Allow Line Disc.")
                {
                    MinOccurs = Zero;
                }
                fieldelement("AllowInvoiceDisc."; "Sales Price"."Allow Invoice Disc.")
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterInitRecord()
                begin
                    "Sales Price"."Source Type" := "Sales Price"."Source Type"::"Customer Price Group";
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        SP2: Record "Price List Line";
}

