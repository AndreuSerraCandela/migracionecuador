page 76170 "Dialogo Login"
{
    ApplicationArea = all;
    Caption = 'Login';
    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            field(Usuario; codUser)
            {
                Caption = 'Usuario';
            }
            field("Contraseña"; texPass)
            {
                Caption = 'Contraseña';
                ExtendedDatatype = Masked;
            }
        }
    }

    actions
    {
    }

    var
        codUser: Code[20];
        texPass: Text[30];


    procedure TraerDatos(var codPrmUser: Code[20]; var texPrmPass: Text[30])
    begin
        codPrmUser := codUser;
        texPrmPass := texPass;
    end;
}

