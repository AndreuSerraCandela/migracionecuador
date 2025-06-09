tableextension 50147 tableextension50147 extends "Warehouse Receipt Line"
{
    fields
    {
        modify("Unit of Measure Code")
        {
            Caption = 'Unit of Measure Code';
        }
        field(50001; "Nº Documento Proveedor"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '#967 - Ecuador';

            trigger OnValidate()
            var
                rLin: Record "Warehouse Receipt Line";
            begin

                // # 967 Actualización en cascada
                rLin.Reset;
                rLin.SetCurrentKey("Source Type", "Source Subtype", "Source No.", "Source Line No.");
                rLin.SetRange("Source Type", "Source Type");
                rLin.SetRange("Source Subtype", "Source Subtype");
                rLin.SetRange("Source Document", "Source Document");
                rLin.SetRange("Source No.", "Source No.");
                rLin.SetRange("No.", "No.");
                if rLin.Find('-') then
                    repeat
                        if (rLin."Line No." <> "Line No.") and (rLin."Qty. to Receive" <> 0) then begin
                            rLin."Nº Documento Proveedor" := "Nº Documento Proveedor";
                            rLin.Modify(true);
                        end;
                    until rLin.Next = 0;
                //#967
            end;
        }
        field(50002; "Nº Proveedor"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '#967 - Ecuador';
            TableRelation = Vendor;
        }
    }
}

