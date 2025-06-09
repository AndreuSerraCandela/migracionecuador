#pragma implicitwith disable
page 76161 "Consulta Últ. Ranking General"
{
    ApplicationArea = all;
    Caption = 'Consulta Últ. Ranking General';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Tabla trabajo Ranking";
    SourceTableView = SORTING(Reporte, "Campaña", "Delegación", "No. Orden")
                      WHERE(Reporte = CONST(General));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(FechaGen; Rec.FechaGen)
                {
                    Caption = 'Fecha Gen.';
                }
                field("Campaña"; Rec."Campaña")
                {
                }
                field("Delegación"; Rec."Delegación")
                {
                }
                field("No. Orden"; Rec."No. Orden")
                {
                }
                field("Cod. Colegio"; Rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; Rec."Nombre Colegio")
                {
                }
                field(Distrito; Rec.Distrito)
                {
                }
                field(Zona; Rec.Zona)
                {
                }
                field("CVM GN"; Rec."CVM GN")
                {
                }
                field("CVM TEXTO_GEN"; Rec."CVM TEXTO_GEN")
                {
                    Caption = 'CVM TEXTO GEN';
                }
                field("CVM TEXTO_INI"; Rec."CVM TEXTO_INI")
                {
                    Caption = 'CVM TEXTO INI';
                }
                field("CVM TEXTO_PRI"; Rec."CVM TEXTO_PRI")
                {
                    Caption = 'CVM TEXTO PRI';
                }
                field("CVM TEXTO_SEC"; Rec."CVM TEXTO_SEC")
                {
                    Caption = 'CVM TEXTO SEC';
                }
                field(RICHMOND_GEN; Rec.RICHMOND_GEN)
                {
                    Caption = 'RICHMOND GEN';
                }
                field(RICHMOND_INI; Rec.RICHMOND_INI)
                {
                    Caption = 'RICHMOND INI';
                }
                field(RICHMOND_PRI; Rec.RICHMOND_PRI)
                {
                    Caption = 'RICHMOND PRI';
                }
                field(RICHMOND_SEC; Rec.RICHMOND_SEC)
                {
                    Caption = 'RICHMOND SEC';
                }
                field("PLAN LECTOR_GEN"; Rec."PLAN LECTOR_GEN")
                {
                    Caption = 'PLAN LECTOR GEN';
                }
                field("PLAN LECTOR_INI"; Rec."PLAN LECTOR_INI")
                {
                    Caption = 'PLAN LECTOR INI';
                }
                field("PLAN LECTOR_PRI"; Rec."PLAN LECTOR_PRI")
                {
                    Caption = 'PLAN LECTOR PRI';
                }
                field("PLAN LECTOR_SEC"; Rec."PLAN LECTOR_SEC")
                {
                    Caption = 'PLAN LECTOR SEC';
                }
                field(COMPARTIR_GEN; Rec.COMPARTIR_GEN)
                {
                    Caption = 'COMPARTIR GEN';
                }
                field(COMPARTIR_INI; Rec.COMPARTIR_INI)
                {
                    Caption = 'COMPARTIR INI';
                }
                field(COMPARTIR_PRI; Rec.COMPARTIR_PRI)
                {
                    Caption = 'COMPARTIR PRI';
                }
                field(COMPARTIR_SEC; Rec.COMPARTIR_SEC)
                {
                    Caption = 'COMPARTIR SEC';
                }
                field("MONTO BRUTO_INI"; Rec."MONTO BRUTO_INI")
                {
                    Caption = 'MONTO BRUTO INI';
                }
                field("MONTO BRUTO_PRI"; Rec."MONTO BRUTO_PRI")
                {
                    Caption = 'MONTO BRUTO PRI';
                }
                field("MONTO BRUTO_SEC"; Rec."MONTO BRUTO_SEC")
                {
                    Caption = 'MONTO BRUTO SEC';
                }
                field("MONTO BRUTO_ING"; Rec."MONTO BRUTO_ING")
                {
                    Caption = 'MONTO BRUTO ING';
                }
                field("MONTO BRUTO_READ"; Rec."MONTO BRUTO_READ")
                {
                    Caption = 'MONTO BRUTO READ';
                }
                field("MONTO BRUTO_PLA"; Rec."MONTO BRUTO_PLA")
                {
                    Caption = 'MONTO BRUTO PLA';
                }
                field("MONTO BRUTO_LETI"; Rec."MONTO BRUTO_LETI")
                {
                    Caption = 'MONTO BRUTO LETI';
                }
                field("MONTO BRUTO_DICC"; Rec."MONTO BRUTO_DICC")
                {
                    Caption = 'MONTO BRUTO DICC';
                }
                field("MONTO BRUTO_BIBL"; Rec."MONTO BRUTO_BIBL")
                {
                    Caption = 'MONTO BRUTO BIBL';
                }
                field("MONTO BRUTO_GENERAL"; Rec."MONTO BRUTO_GENERAL")
                {
                    Caption = 'MONTO BRUTO GENERAL';
                }
                field("MONTO TOTAL_ESPAÑOL"; Rec."MONTO TOTAL_ESPAÑOL")
                {
                    Caption = 'MONTO TOTAL ESPAÑOL';
                }
                field("MONTO TOTAL_INGLES"; Rec."MONTO TOTAL_INGLES")
                {
                    Caption = 'MONTO TOTAL INGLES';
                }
                field("MONTO TOTAL_PLAN LECTOR"; Rec."MONTO TOTAL_PLAN LECTOR")
                {
                    Caption = 'MONTO TOTAL PLAN LECTOR';
                }
                field("MONTO TOTAL_GENERAL"; Rec."MONTO TOTAL_GENERAL")
                {
                    Caption = 'MONTO TOTAL GENERAL';
                }
                field("PORC MONTO BRUTO_ESPAÑOL"; Rec."PORC MONTO BRUTO_ESPAÑOL")
                {
                    Caption = 'PORC. MONTO BRUTO ESPAÑOL';
                }
                field("PORC MONTO BRUTO_INGLES"; Rec."PORC MONTO BRUTO_INGLES")
                {
                    Caption = 'PORC. MONTO BRUTO INGLES';
                }
                field("PORC MONTO BRUTO_PLAN LECTOR"; Rec."PORC MONTO BRUTO_PLAN LECTOR")
                {
                    Caption = 'PORC. MONTO BRUTO PLAN LECTOR';
                }
                field("PORC MONTO BRUTO_GENERAL"; Rec."PORC MONTO BRUTO_GENERAL")
                {
                    Caption = 'PORC. MONTO BRUTO GENERAL';
                }
            }
            group(Control1000000037)
            {
                ShowCaption = false;
                Visible = false;
                field(TextFecha; TextFecha)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Clear(TextFecha);
        //IF FINDFIRST THEN
        //  TextFecha := STRSUBSTNO(Text001,FechaGen);
    end;

    var
        Text001: Label 'Generado a fecha: %1.';
        TextFecha: Text[50];
}

#pragma implicitwith restore

