page 76402 "Sub - Aturozicaciones TPV BOL"
{
    ApplicationArea = all;
    Caption = 'Autorizaciones Manuales x Tienda';
    DelayedInsert = true;
    DeleteAllowed = true;
    PageType = ListPart;
    SourceTable = "_Autoriz. Manuales TPV BO";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Autorizacion; rec.Autorizacion)
                {
                }
                field("Fecha Inicial"; rec."Fecha Inicial")
                {
                    Enabled = false;
                }
                field("Fecha Final"; rec."Fecha Final")
                {
                    Editable = false;
                }
                field("Nº Inicial"; rec."Nº Inicial")
                {
                    Editable = false;
                }
                field("No Final"; rec."No Final")
                {
                    Editable = false;
                }
                field("Descripción"; rec.Descripción)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        cfBol: Codeunit "Funciones DsPOS - Bolivia";
        rConf: Record "Configuracion General DsPOS";
    begin

        rec.SetFilter("Filtro Fecha", '%1..|%2', Today, 0D);

        rConf.Get();
        /*if rConf.Pais = rConf.Pais::Bolivia then  // TPV Bolivia
            cfBol.ActualizaAutorizaciones(wTienda);*/
    end;

    var
        wTienda: Code[20];


    procedure recogerPar(pTienda: Code[20])
    begin

        wTienda := pTienda;
    end;
}

