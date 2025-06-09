page 76376 "Reloj control asist. Card"
{
    ApplicationArea = all;
    SourceTable = "Parametros Reloj Control Asist";

    layout
    {
        area(content)
        {
            group("Database information")
            {
                Caption = 'Database information';
                field("Clock ID"; rec."Clock ID")
                {
                }
                field(Description; rec.Description)
                {
                }
                field(Provider; rec.Provider)
                {
                }
                field("Data Source"; rec."Data Source")
                {
                }
                field("Initial Catalog"; rec."Initial Catalog")
                {
                }
                field(User; rec.User)
                {
                }
                field(Password; rec.Password)
                {
                    ExtendedDatatype = Masked;
                }
            }
            group("Table fields information")
            {
                Caption = 'Table fields information';
                field("Nombre tabla ponchador"; rec."Nombre tabla ponchador")
                {
                }
                field("ID Campo Cod. Empleado"; rec."ID Campo Cod. Empleado")
                {
                }
                field("ID Campo Cod. tarjeta"; rec."ID Campo Cod. tarjeta")
                {
                }
                field("ID Campo Fecha registro"; rec."ID Campo Fecha registro")
                {
                }
                field("ID Campo Hora registro"; rec."ID Campo Hora registro")
                {
                }
                field("ID Campo ID Equipo"; rec."ID Campo ID Equipo")
                {
                }
                field("Nombre campo filtro de fecha"; rec."Nombre campo filtro de fecha")
                {
                }
            }
        }
    }

    actions
    {
    }
}

