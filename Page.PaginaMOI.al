page 56034 PaginaMOI
{
    ApplicationArea = all;
    // MOI - 31/12/2014: Se crea la pagina
    // MOI - 13/04/2015: Se añaden los campos Tipo e ID con las funciones correspondientes para hacerlos visibles y obtener los datos.
    // MOI - 21/04/2015: Se añaden los campos Factura y RUC con las funciones correspondientes para hacerlos visibles y obtener los datos.
    //                   Se renombran los campos, para hacerlos mas coherentes.
    // MOI - 26/05/2015: Se añade el campo No. Devolucion con las funciones correspondientes para hacerlo visible y obtener los datos.
    // #39836  15/12/2015  MOI   Se añade el campo NCF con las funciones correspondientes para hacerlos visible y obtener los datos.

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            field(Tipo; goTipo)
            {
                Caption = 'Indique el tipo de objeto';
                Visible = isVisibleTipo;

                trigger OnValidate()
                begin
                    /*
                    lrPermisosLicencia.SETRANGE(lrPermisosLicencia."Object Type",lrPermisosLicencia."Object Type"::TableData);//0
                    lrPermisosLicencia.SETRANGE(lrPermisosLicencia."Object Type",lrPermisosLicencia."Object Type"::Table);//1
                    lrPermisosLicencia.SETRANGE(lrPermisosLicencia."Object Type",lrPermisosLicencia."Object Type"::"2");//2
                    lrPermisosLicencia.SETRANGE(lrPermisosLicencia."Object Type",lrPermisosLicencia."Object Type"::Report);//3
                    lrPermisosLicencia.SETRANGE(lrPermisosLicencia."Object Type",lrPermisosLicencia."Object Type"::"4");//4
                    lrPermisosLicencia.SETRANGE(lrPermisosLicencia."Object Type",lrPermisosLicencia."Object Type"::Codeunit);//5
                    lrPermisosLicencia.SETRANGE(lrPermisosLicencia."Object Type",lrPermisosLicencia."Object Type"::XMLport);//6
                    lrPermisosLicencia.SETRANGE(lrPermisosLicencia."Object Type",lrPermisosLicencia."Object Type"::MenuSuite);//7
                    lrPermisosLicencia.SETRANGE(lrPermisosLicencia."Object Type",lrPermisosLicencia."Object Type"::Page);//8
                    lrPermisosLicencia.SETRANGE(lrPermisosLicencia."Object Type",lrPermisosLicencia."Object Type"::Query);//9
                    lrPermisosLicencia.SETRANGE(lrPermisosLicencia."Object Type",lrPermisosLicencia."Object Type"::System);//10
                    lrPermisosLicencia.SETRANGE(lrPermisosLicencia."Object Type",lrPermisosLicencia."Object Type"::FieldNumber);//11
                    lrPermisosLicencia.SETRANGE(lrPermisosLicencia."Object Type",lrPermisosLicencia."Object Type"::LimitedUsageTableData);//12
                    */

                end;
            }
            field(ID; giID)
            {
                Caption = 'Indique el numero del objeto';
                Visible = isVisibleID;

                trigger OnValidate()
                begin
                    if giID = 0 then
                        Error('El ID no puede ser 0');
                end;
            }
            field(Factura; gcFactura)
            {
                Caption = 'Introduzca la factura';
                Visible = isVisibleFactura;

                trigger OnValidate()
                begin
                    if gcFactura = '' then
                        Error('La factura no puede estar vacia');
                end;
            }
            field(RUC; gtRUC)
            {
                Caption = 'Introduzca el RUC';
                Visible = isVisibleRUC;

                trigger OnValidate()
                begin
                    if gtRUC = '' then
                        Error('El RUC no puede estar vacio');
                end;
            }
            field(NoDevolucion; gcNoDevolucion)
            {
                Caption = 'Introduzca el No. de la devolucion que desea eliminar';
                Visible = isVisibleNoDevolucion;
            }
            field(NCF; gcNCF)
            {
                Caption = 'Introduzca el NCF';
                Description = '#39836';
                Visible = isVisibleNCF;
            }
        }
    }

    actions
    {
    }

    var

        isVisibleTipo: Boolean;

        isVisibleID: Boolean;
        goTipo: Option ,Tabla,,"Report",,"CodeUnit","XMLPort",MenuSuite,"Page","Query";
        giID: Integer;
        gcFactura: Code[20];
        gtRUC: Text[30];

        isVisibleFactura: Boolean;

        isVisibleRUC: Boolean;
        gcNoDevolucion: Code[20];

        isVisibleNoDevolucion: Boolean;
        gcNCF: Code[30];

        isVisibleNCF: Boolean;


    procedure GetTipo(): Integer
    begin
        exit(goTipo);
    end;


    procedure GetID(): Integer
    begin
        exit(giID);
    end;


    procedure GetFactura(): Code[20]
    begin
        exit(gcFactura);
    end;


    procedure GetRUC(): Text[30]
    begin
        exit(gtRUC);
    end;


    procedure GetNoDevolucion(): Code[20]
    begin
        exit(gcNoDevolucion);
    end;


    procedure SetVisibleTipo(visible: Boolean)
    begin
        isVisibleTipo := visible;
    end;


    procedure SetVisibleID(visible: Boolean)
    begin
        isVisibleID := visible;
    end;


    procedure SetVisibleFactura(visible: Boolean)
    begin
        isVisibleFactura := visible;
    end;


    procedure SetVisibleRUC(visible: Boolean)
    begin
        isVisibleRUC := visible;
    end;


    procedure SetVisibleNoDevolucion(visible: Boolean)
    begin
        isVisibleNoDevolucion := visible;
    end;


    procedure GetNCF(): Code[30]
    begin
        //#39836:Inicio
        exit(gcNCF);
        //#39836:Fin
    end;


    procedure SetVisibleNCF(visible: Boolean)
    begin
        //#39836:Inicio
        isVisibleNCF := visible;
        //#39836:Fin
    end;
}

