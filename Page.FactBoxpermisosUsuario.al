page 76211 "FactBox permisos Usuario"
{
    ApplicationArea = all;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            field(texTipo; texTipo)
            {
                Importance = Promoted;
                ShowCaption = false;
                StyleExpr = texPermisos;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

        if recCajero.Get(codTienda, codUsuario) then begin
            case recCajero.Tipo of
                recCajero.Tipo::Cajero:
                    begin
                        texTipo := Text001;
                        texPermisos := Text003;
                    end;
                recCajero.Tipo::Supervisor:
                    begin
                        texTipo := Text002;
                        texPermisos := Text004;
                    end;
            end;
        end;
    end;

    var
        recCajero: Record Cajeros;
        codTienda: Code[20];
        codUsuario: Code[20];
        texTipo: Text;
        Text001: Label 'CAJERO';
        Text002: Label 'SUPERVISOR';
        Text003: Label 'Unfavorable';
        Text004: Label 'Favorable';
        texPermisos: Text;


    procedure PasarDatos(codPrmTienda: Code[20]; codPrmUsuario: Code[20])
    begin
        codTienda := codPrmTienda;
        codUsuario := codPrmUsuario;
    end;
}

