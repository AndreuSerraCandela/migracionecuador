#pragma implicitwith disable
page 55028 "Datos Exportación - Factura"
{
    ApplicationArea = all;
    PageType = Card;
    Permissions = TableData "Sales Invoice Header" = rm;
    SourceTable = "Sales Invoice Header";

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
                field("Tipo Exportacion"; rec."Tipo Exportacion")
                {
                    Editable = bExportac;
                }
                field("Con Refrendo"; rec."Con Refrendo")
                {
                    Editable = bExportac;
                    Visible = false;

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
                    Editable = bExportac;
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

        //+#34853
        //bRefrendo := ("Con Refrendo") AND (Exportación);
        bRefrendo := (Rec."Tipo Exportacion" = Rec."Tipo Exportacion"::"01") and (Rec."Exportación");
        //-#34853
    end;


    procedure ActivaExportac()
    begin
        bExportac := Rec."Exportación";
        ActivaNoRefrendo;
    end;
}

#pragma implicitwith restore

