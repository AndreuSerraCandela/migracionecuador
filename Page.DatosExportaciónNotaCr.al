#pragma implicitwith disable
page 56085 "Datos Exportación - Nota Cr."
{
    ApplicationArea = all;
    PageType = Card;
    Permissions = TableData "Sales Cr.Memo Header" = rm;
    SourceTable = "Sales Cr.Memo Header";

    layout
    {
        area(content)
        {
            group("Datos Exportación")
            {
                Caption = 'Datos Exportación';
                field("Exportación"; rec.Exportación)
                {

                    trigger OnValidate()
                    begin
                        ActivaExportac;
                    end;
                }
                field("Valor FOB"; rec."Valor FOB")
                {
                    Editable = bExportac;
                }
                field("Valor FOB Comprobante Local"; rec."Valor FOB Comprobante Local")
                {
                    Editable = bExportac;
                }
                field("Con Refrendo"; rec."Con Refrendo")
                {
                    Editable = bExportac;

                    trigger OnValidate()
                    begin
                        ActivaNoRefrendo;
                    end;
                }
                field("No. refrendo - distrito adua."; rec."No. refrendo - distrito adua.")
                {
                    Editable = bRefrendo;
                }
                field("No. refrendo - Año"; rec."No. refrendo - Año")
                {
                    Editable = bRefrendo;
                }
                field("No. refrendo - regimen"; rec."No. refrendo - regimen")
                {
                    Editable = bRefrendo;
                }
                field("No. refrendo - Correlativo"; rec."No. refrendo - Correlativo")
                {
                    Editable = bRefrendo;
                }
                field("Fecha embarque"; rec."Fecha embarque")
                {
                    Editable = bRefrendo;
                }
                field("Nº Documento Transporte"; rec."Nº Documento Transporte")
                {
                    Editable = bRefrendo;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ActivaNoRefrendo;
        ActivaExportac;
    end;

    trigger OnOpenPage()
    begin
        ActivaNoRefrendo;
        ActivaExportac;
    end;

    var
        bRefrendo: Boolean;
        bExportac: Boolean;


    procedure ActivaNoRefrendo()
    begin

        bRefrendo := (Rec."Con Refrendo") and (Rec."Exportación");
    end;


    procedure ActivaExportac()
    begin
        bExportac := Rec."Exportación";
        ActivaNoRefrendo;
    end;
}

#pragma implicitwith restore

