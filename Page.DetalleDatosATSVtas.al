#pragma implicitwith disable
page 55012 "Detalle Datos ATS Vtas."
{
    ApplicationArea = all;
    // #34860  CAT   11/11/2015  Gestionar el No. de establecimientos

    Caption = 'ATS Vtas x Cliente';
    Editable = false;
    PageType = List;
    SourceTable = "ATS Ventas x Cliente";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod.Cliente"; Rec."Cod.Cliente")
                {
                }
                field("Nombre Cliente"; Rec."Nombre Cliente")
                {
                }
                field("Tipo Identificacion Cliente"; Rec."Tipo Identificacion Cliente")
                {
                }
                field("No. Identificación Cliente"; Rec."No. Identificación Cliente")
                {
                }
                field("Parte Relacionada"; Rec."Parte Relacionada")
                {
                }
                field("Codigo Tipo Comprobante"; Rec."Codigo Tipo Comprobante")
                {
                }
                field("No. de Comprobantes"; Rec."No. de Comprobantes")
                {
                }
                field("Base Imponible No objeto IVA"; Rec."Base Imponible No objeto IVA")
                {
                }
                field("Base Imponible 0% IVA"; Rec."Base Imponible 0% IVA")
                {
                }
                field("Base Imposible 12% IVA"; Rec."Base Imposible 12% IVA")
                {
                }
                field("Monto IVA"; Rec."Monto IVA")
                {
                }
                field("Valor IVA retenido"; Rec."Valor IVA retenido")
                {
                }
                field("Valor Renta retenido"; Rec."Valor Renta retenido")
                {
                }
            }
            field("'No. de Establec.: ' + noEstab"; 'No. de Establec.: ' + noEstab)
            {
                StyleExpr = TRUE;
            }
            part(Control1000000013; "ATS ventas Establecimiento")
            {
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

        //+#34860
        if Rec.FindSet then begin
            noEstab := '';
            Env.SetRange(Env.Mes, Rec."Mes -  Periodo");
            Env.SetRange(Env.Año, Rec."Año - Periodo");
            if Env.FindSet then
                noEstab := Format(Env."No. Establecimientos");
        end;
        //-#34860
    end;

    var
        Env: Record "Envios ATS";
        noEstab: Text[10];
}

#pragma implicitwith restore

