table 76016 Tiendas
{
    // #90735 RRT,  15.09.2017: Añadir campo "ID Sesion" para controlar si alguién esa ejecutando una función crítica (Registrar, Nueva_Venta,..)
    // #88460 RRT,  01.02.2018: Añadir un nuevo campo para permitir grabar un LOG.
    // #76946 RRT,  13.12.2017: Añadir 2 campos para la impresión de facturas electrónicas
    //              26.12.2017: Añadir campos de e-mail e "Información zona" para la impresión de facturas electrónicas.
    // 
    // #121213 RRT, 13.03.2018: Cambiar ID del campo "Registrar log del proceso" a 76442. Su valor chocaba con uno de los campos nuevos de Guatemala.
    //         De todas formas este campo, tiene el valor inicial y que yo sepa siempre se permite el registrar el LOG. Ni siquiera sale en la ficha.
    // 
    // 
    // 
    // Proyecto: Microsoft Dynamics Nav
    // ------------------------------------------------------------------------------
    // FES   : Fausto Serrata
    // ------------------------------------------------------------------------------
    // No.                 Firma         Fecha           Descripción
    // ------------------------------------------------------------------------------
    // SANTINAV-1561       FES           05-08-2020      Funcionalidad Cupones Electronicos.
    //                                                   Colocar "Lista Tienda" en propiedad LookupPageID
    // 
    // #348662 25.11.2020  RRT: Actualizar DS-POS para ajustar a version 43c. Redenominar tambien campos con caracteres conflictivos.
    //                          Añadir el campo "Generación cupones digitales" (Dynasoft Dominicana)
    // 
    // #374964 26.04.2020  RRT: Nuevo campo para indicar que las NCR deben realizarse siempre en esa forma de pago.

    Caption = 'Stores';
    LookupPageID = "Lista Tiendas";

    fields
    {
        field(76046; "Cod. Tienda"; Code[20])
        {
            Caption = 'Store Code';
            Description = 'DsPOS Standard';
            NotBlank = true;
        }
        field(76029; Descripcion; Text[200])
        {
            Caption = 'Description';
            Description = 'DsPOS Standard';
        }
        field(76011; "Cod. Almacen"; Code[20])
        {
            Caption = 'Location code';
            Description = 'DsPOS Standard';
            TableRelation = Location.Code;

            trigger OnValidate()
            var
                Location: Record Location;
            begin

                if Location.Get("Cod. Almacen") then begin

                    Location.TestField("Require Receive", false);
                    Location.TestField("Require Shipment", false);
                    Location.TestField("Require Put-away", false);
                    Location.TestField("Use Put-away Worksheet", false);
                    Location.TestField("Require Pick", false);
                    Location.TestField("Bin Mandatory", false);

                    Direccion := Location.Address;
                    Telefono := Location."Phone No.";
                    "Direccion 2" := Location."Address 2";
                    "Pagina web" := Location."Home Page";
                    "Telefono 2" := Location."Phone No. 2";
                    "Cod. Pais" := Location."Country/Region Code";
                    Ciudad := Location.City;
                end
                else begin
                    Direccion := '';
                    Telefono := '';
                    "Direccion 2" := '';
                    "Pagina web" := '';
                    "Telefono 2" := '';
                    "Cod. Pais" := '';
                    Ciudad := '';
                end;
            end;
        }
        field(76016; Direccion; Text[250])
        {
            Caption = 'Address';
            Description = 'DsPOS Standard';
        }
        field(76018; Telefono; Text[250])
        {
            Caption = 'Phone no.';
            Description = 'DsPOS Standard';
        }
        field(76015; Fax; Text[30])
        {
            Caption = 'Fax';
            Description = 'DsPOS Standard';
        }
        field(76026; "Direccion 2"; Text[250])
        {
            Caption = 'Address 2';
            Description = 'DsPOS Standard';
        }
        field(76020; "Pagina web"; Text[250])
        {
            Caption = 'Web page';
            Description = 'DsPOS Standard';
        }
        field(76022; "Telefono 2"; Text[30])
        {
            Caption = 'Phono no. 2';
            Description = 'DsPOS Standard';
        }
        field(76027; "No. Identificacion Fiscal"; Text[50])
        {
            Caption = 'VAT Registration No.';
            Description = 'DsPOS Standard';
        }
        field(76021; "Cod. Pais"; Code[20])
        {
            Caption = 'Country Code';
            Description = 'DsPOS Standard';
            TableRelation = "Country/Region";
        }
        field(76030; Ciudad; Code[20])
        {
            Caption = 'City';
            Description = 'DsPOS Standard';
        }
        field(76227; "Descripcion recibo TPV"; Text[250])
        {
            Caption = 'POS Receipt text';
            Description = 'DsPOS Standard';
        }
        field(76313; "Descripcion recibo TPV 2"; Text[250])
        {
            Caption = 'POS Receipt text';
            Description = 'DsPOS Standard';
        }
        field(76228; "Descripcion recibo TPV 3"; Text[250])
        {
            Caption = 'POS Receipt text';
            Description = 'DsPOS Standard';
        }
        field(76315; "Descripcion recibo TPV 4"; Text[250])
        {
            Caption = 'POS Receipt text';
            Description = 'DsPOS Standard';
        }
        field(76019; "Nombre Pais"; Text[50])
        {
            Caption = 'Nombre País';
            Description = 'DsPOS Standard';

            trigger OnValidate()
            var
                rPais: Record "Country/Region";
            begin

                if rPais.Get("Cod. Pais") then
                    "Nombre Pais" := rPais.Name
                else
                    "Nombre Pais" := '';
            end;
        }
        field(76009; "Control de caja"; Boolean)
        {
            Caption = 'Control de caja';
            Description = 'DsPOS Standard';
        }
        field(76004; "Descuadre maximo en caja"; Decimal)
        {
            Caption = 'Descuadre máximo en caja';
            Description = 'DsPOS Standard';
            MinValue = 0;
        }
        field(76073; "Arqueo de caja obligatorio"; Boolean)
        {
            Caption = 'Arqueo de caja obligatorio';
            Description = 'DsPOS Standard';
        }
        field(76076; "ID Reporte contado"; Integer)
        {
            Caption = 'Cash Receipt ID';
            Description = 'DsPOS Standard';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(76215; "ID Reporte contado FE"; Integer)
        {
            Caption = 'Cash Receipt ID FE ';
            Description = 'DsPOS Standard,#76946,GUATEMALA';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(76314; "ID Reporte nota credito"; Integer)
        {
            Caption = 'ID Reporte nota credito';
            Description = 'DsPOS Standard';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(76408; "ID Reporte nota credito FE"; Integer)
        {
            Caption = 'ID Reporte nota credito FE';
            Description = 'DsPOS Standard,#76946,GUATEMALA';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(76169; "ID Reporte venta a credito"; Integer)
        {
            Caption = 'Credit sales report ID';
            Description = 'DsPOS Standard';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(76265; "ID Reporte cuadre"; Integer)
        {
            Caption = 'Balancing report ID';
            Description = 'DsPOS Standard';
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(76176; "Cantidad de Copias Contado"; Integer)
        {
            Caption = 'Cantidad de Copias venta contado';
            Description = 'DsPOS Standard';
        }
        field(76435; "Cantidad de Copias Credito"; Integer)
        {
            Caption = 'Cantidad de Copias venta a credito';
            Description = 'DsPOS Standard';
        }
        field(76436; "Registro En Linea"; Boolean)
        {
            Caption = 'Registro En Linea';
            Description = 'DsPOS Standard';
        }
        field(76443; "Agrupar Lineas"; Boolean)
        {
            Caption = 'Agrupar Lineas';
            Description = 'DsPOS Standard';
        }
        field(76444; "Cantidad copias nota credito"; Integer)
        {
            Caption = 'Cantidad de Copias Nota Credito';
            Description = 'DsPOS Standard';
        }
        field(76445; "Permite Anulaciones en POS"; Boolean)
        {
            Description = 'DsPOS Standard';

            trigger OnValidate()
            begin

                /*                if not "Permite Anulaciones en POS" then
                                   cFunciones.DeconfiguraAnulaciones(Rec) */
                ;
            end;
        }
        field(76446; "Instancia Completa SQL"; Text[250])
        {
            Description = 'DsPOS Standard';
        }
        field(76447; "Imp. Minimo Sol. Datos Cliente"; Decimal)
        {
            Caption = 'Importe mínimo para solicitar datos del cliente';
            Description = 'DsPOS Standard';
        }
        field(76448; "No. Maximo de Lineas"; Integer)
        {
            Description = 'DsPOS Standard';
            InitValue = 20;
            MaxValue = 999;
            MinValue = 1;
            NotBlank = true;
        }
        field(76449; "No. Reaperturas Permitidas"; Integer)
        {
            Description = 'DsPOS Standard';
        }
        field(76437; "Cuenta Excencion IVA"; Code[20])
        {
            Caption = 'Cuenta Excención IVA';
            Description = 'DsPOS Standard';
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));

            trigger OnValidate()
            var
                rCue: Record "G/L Account";
            begin

                if "Cuenta Excencion IVA" <> '' then begin
                    rCue.Get("Cuenta Excencion IVA");
                    rCue.TestField("Account Type", rCue."Account Type"::Posting);
                end;
            end;
        }
        field(76450; "ID Sesion"; Integer)
        {
            Description = '#90735';
        }
        field(76451; "e-mail"; Text[80])
        {
            Description = 'DsPOS Standard,#76946,GUATEMALA';
        }
        field(76452; "Informacion zona"; Text[30])
        {
            Description = 'DsPOS Standard,#76946,GUATEMALA';
        }
        field(76453; "Permite NC en otro TPV"; Boolean)
        {
            Description = 'DsPOS Standard';
            InitValue = true;
        }
        field(76454; "Permite NC en otro Turno"; Boolean)
        {
            Description = 'DsPOS Standard';
            InitValue = true;
        }
        field(76455; "Codigo Postal"; Code[10])
        {
        }
        field(76456; "Nombre Empresa 1"; Text[50])
        {
        }
        field(76457; "Genera Cupones Digitales"; Boolean)
        {
            Description = 'SANTINAV-1862 // #347435';
        }
        field(76458; "Cantidad devolucion config"; Boolean)
        {
            Caption = 'Cantidad devolucion configurable';
            Description = 'SANTINAV-1865 // #355717';
        }
        field(76459; "Forma pago para NCR"; Code[10])
        {
            Description = 'SANTINAV-2362 // #374964';
            TableRelation = "Formas de Pago";
        }
    }

    keys
    {
        key(Key1; "Cod. Tienda")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cod. Tienda", Descripcion)
        {
        }
    }

    trigger OnDelete()
    var
        rConfTPV: Record "Configuracion TPV";
    begin

        rConfTPV.Reset;
        rConfTPV.SetRange(Tienda, "Cod. Tienda");
        if rConfTPV.FindSet then begin
            if not Confirm(StrSubstNo(text001, "Cod. Tienda"), false) then
                Error(Error001);
            rConfTPV.DeleteAll(false);
        end;
    end;

    trigger OnInsert()
    begin
        TestField("Cod. Tienda");
    end;

    var
        rBanco: Record "Bank Account";
        text001: Label 'La tienda %1 tiene TPV''s configurados, si continua se BORRARAN todos ¿Continuar?';
        Error001: Label 'Proceso Cancelado a petición del usuario';
    //Error002: '';
    /*     cFunciones: Codeunit "Funciones DsPOS - Comunes"; */
}

