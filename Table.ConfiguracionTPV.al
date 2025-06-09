table 76029 "Configuracion TPV"
{
    // 001  04/04/2017  PLB: Eliminada la propiedad "Table Relation" del campo "Id TPV"
    // #76946  07.12.2017   RRT: Creación del campo "Texto Aviso FE" (GT)
    // #116527 22.01.2018   RRT: Creacion de los campos "NCF credito fiscal resguardo" y "NCF credito fiscal NCR resg." (GT)
    //         11.02.2018   RRT: Creacion de los campos "NCF credito fiscal habitual" y "NCF credito fiscal NCR habit." (GT)
    // 
    // #175576 13.11.2018   RRT: Introducción del campo de tipo Option "Precios por contrato".
    // #232158 20.06.2019   RRT: Las series NCF dejan de usarse.
    // #328529 05.08.2020   RRT: Actualización DS-POS por desarrollo #325138 de El Salvador.
    // #348662 25.11.2020  RRT: Actualizar DS-POS para ajustar a version 43c. Redenominar tambien campos con caracteres conflictivos.

    Caption = 'TPV Configuration';

    fields
    {
        field(76046; Tienda; Code[20])
        {
            Caption = 'Store';
            Description = 'DsPOS Standard';
            TableRelation = Tiendas."Cod. Tienda";
        }
        field(76029; "Id TPV"; Code[20])
        {
            Caption = 'Id TPV';
            Description = 'DsPOS Standard';
        }
        field(76011; Descripcion; Text[200])
        {
            Caption = 'Descripción';
            Description = 'DsPOS Standard';
        }
        field(76016; "No. serie Facturas"; Code[20])
        {
            Caption = 'Nº Serie Facturas';
            Description = 'DsPOS Standard';
            TableRelation = "No. Series";
        }
        field(76018; "Menu de acciones"; Code[20])
        {
            Caption = 'Menú de acciones';
            Description = 'DsPOS Standard';
            TableRelation = "Menus TPV" WHERE("Tipo Menu" = CONST(Acciones));

            trigger OnValidate()
            begin

                CompruebaMenu(1, "Menu de acciones");
            end;
        }
        field(76015; "Menu de productos"; Code[20])
        {
            Caption = 'Menú de productos';
            Description = 'DsPOS Standard';
            TableRelation = "Menus TPV" WHERE("Tipo Menu" = CONST(Productos));

            trigger OnValidate()
            begin
                CompruebaMenu(3, "Menu de productos");
            end;
        }
        field(76026; "Menu de Formas de Pago"; Code[20])
        {
            Caption = 'Menú de Formas de Pago';
            Description = 'DsPOS Standard';
            TableRelation = "Menus TPV" WHERE("Tipo Menu" = CONST(Pagos));

            trigger OnValidate()
            begin
                CompruebaMenu(2, "Menu de Formas de Pago");
            end;
        }
        field(76313; "Usuario windows"; Text[64])
        {
            Caption = 'Usuario windows';
            Description = 'DsPOS Standard';
            Editable = true;
        }
        field(76009; "No. serie facturas Reg."; Code[20])
        {
            Caption = 'Nº serie facturas Registradas';
            Description = 'DsPOS Standard';
            TableRelation = "No. Series";
        }
        field(76004; "No. serie notas credito"; Code[20])
        {
            Caption = 'Nº serie notas crédito';
            Description = 'DsPOS Standard';
            TableRelation = "No. Series";
        }
        field(76073; "No. serie notas credito reg."; Code[20])
        {
            Caption = 'Nº serie notas crédito registradas';
            Description = 'DsPOS Standard';
            TableRelation = "No. Series";
        }
        field(76076; "Descripcion tienda"; Text[200])
        {
            CalcFormula = Lookup(Tiendas.Descripcion WHERE("Cod. Tienda" = FIELD(Tienda)));
            Caption = 'Descripción tienda';
            Description = 'DsPOS Standard';
            FieldClass = FlowField;
        }
        field(76215; "Importe ventas Tienda"; Decimal)
        {
            CalcFormula = Sum("Transacciones TPV"."Importe IVA inc." WHERE("Cod. tienda" = FIELD(Tienda),
                                                                            Fecha = FIELD("Filtro fecha")));
            Caption = 'Importe ventas Tienda';
            Description = 'DsPOS Standard';
            FieldClass = FlowField;
        }
        field(76405; "Importe cobros Tienda"; Decimal)
        {
            CalcFormula = Sum("Transacciones Caja TPV"."Importe (DL)" WHERE("Cod. tienda" = FIELD(Tienda),
                                                                             Fecha = FIELD("Filtro fecha"),
                                                                             "Tipo transaccion" = FILTER("Cobro TPV" | Anulacion)));
            Caption = 'Importe cobros Tienda';
            Description = 'DsPOS Standard';
            FieldClass = FlowField;
        }
        field(76024; "Importe ventas"; Decimal)
        {
            CalcFormula = Sum("Transacciones TPV"."Importe IVA inc." WHERE("Cod. tienda" = FIELD(Tienda),
                                                                            "Cod. TPV" = FIELD("Id TPV"),
                                                                            Fecha = FIELD("Filtro fecha")));
            Caption = 'Importe ventas';
            Description = 'DsPOS Standard';
            FieldClass = FlowField;
        }
        field(76023; "Importe cobros"; Decimal)
        {
            CalcFormula = Sum("Transacciones Caja TPV"."Importe (DL)" WHERE("Cod. tienda" = FIELD(Tienda),
                                                                             "Cod. TPV" = FIELD("Id TPV"),
                                                                             Fecha = FIELD("Filtro fecha"),
                                                                             "Tipo transaccion" = FILTER("Cobro TPV" | Anulacion)));
            Caption = 'Importe cobros';
            Description = 'DsPOS Standard';
            FieldClass = FlowField;
        }
        field(76265; "NCF Consumidor final"; Code[20])
        {
            Caption = 'NCF Consumidor final';
            Description = 'DsPOS Dominicana';
            TableRelation = "No. Series";
        }
        field(76074; "NCF Credito fiscal"; Code[20])
        {
            Caption = 'NCF Crédito fiscal';
            Description = 'DsPOS Dominicana - DsPOS Paraguay';
            TableRelation = "No. Series";
        }
        field(76312; "NCF Regimenes especiales"; Code[20])
        {
            Caption = 'NCF Regímenes especiales';
            Description = 'DsPOS Dominicana';
            TableRelation = "No. Series";
        }
        field(76213; "NCF Gubernamentales"; Code[20])
        {
            Caption = 'NCF Gubernamentales';
            Description = 'DsPOS Dominicana';
            TableRelation = "No. Series";
        }
        field(76331; "Filtro fecha"; Date)
        {
            Caption = 'Filtro fecha';
            Description = 'DsPOS Standard';
            FieldClass = FlowFilter;
        }
        field(76224; "NCF Credito fiscal habitual"; Code[20])
        {
            Description = 'DsPOS Guatemala,#116527';
            TableRelation = "No. Series";

            trigger OnValidate()
            var
                lrConf: Record "Configuracion General DsPOS";
            /*  lcGuatemala: Codeunit "Funciones DsPOS - Guatemala"; */
            begin
                //+#232158
                //...
                /*
                //+116527
                //... De momento se restringe sólo al caso de Guatemala
                IF lrConf.FINDFIRST THEN
                  IF lrConf.Pais = lrConf.Pais::Guatemala THEN
                    IF NOT lcGuatemala.TestSeriesResguardo(Tienda,"Id TPV") THEN
                      VALIDATE("NCF Credito fiscal","NCF Credito fiscal habitual");
                */
                //-#232158

            end;
        }
        field(76348; "NCF Credito fiscal resguardo"; Code[20])
        {
            Description = 'DsPOS Guatemala,#116527';
            TableRelation = "No. Series";

            trigger OnValidate()
            var
                lrConf: Record "Configuracion General DsPOS";
            /*              lcGuatemala: Codeunit "Funciones DsPOS - Guatemala"; */
            begin
                //+#232158
                //...
                /*
                
                //+116527
                //... De momento se restringe sólo al caso de Guatemala
                IF lrConf.FINDFIRST THEN
                  IF lrConf.Pais = lrConf.Pais::Guatemala THEN
                    IF lcGuatemala.TestSeriesResguardo(Tienda,"Id TPV") THEN
                      VALIDATE("NCF Credito fiscal","NCF Credito fiscal resguardo");
                */
                //-#232158

            end;
        }
        field(76176; "Serie Ventas Computerizadas"; Code[20])
        {
            Description = 'DsPOS Bolivia';
            TableRelation = "No. Series".Code;
        }
        field(76167; "NCF Consumidor final NCR"; Code[20])
        {
            Description = 'DsPOS Dominicana - DsPOS Paraguay';
            TableRelation = "No. Series";
        }
        field(76430; "NCF Credito fiscal NCR"; Code[20])
        {
            Description = 'DsPOS Dominicana - DsPOS Paraguay';
            TableRelation = "No. Series";
        }
        field(76431; "Venta Movil"; Boolean)
        {
            Caption = 'Venta Móvil.';
            Description = 'DsPOS Standard';
        }
        field(76432; "Precio por contacto"; Option)
        {
            Description = 'DsPOS Standard,#175576';
            OptionMembers = "Sólo si hay venta móvil","En todos los casos","En ningún caso";
        }
        field(76433; "NCF Credito fiscal NCR habit."; Code[20])
        {
            Description = 'DsPOS Guatemala,#116527';
            TableRelation = "No. Series";

            trigger OnValidate()
            var
                lrConf: Record "Configuracion General DsPOS";
            /*          lcGuatemala: Codeunit "Funciones DsPOS - Guatemala"; */
            begin
                //+#232158
                //...
                /*
                
                //+116527
                //... De momento se restringe sólo al caso de Guatemala
                IF lrConf.FINDFIRST THEN
                  IF lrConf.Pais = lrConf.Pais::Guatemala THEN
                    IF NOT lcGuatemala.TestSeriesResguardo(Tienda,"Id TPV") THEN
                      VALIDATE("NCF Credito fiscal NCR","NCF Credito fiscal NCR habit.");
                */
                //-#232158

            end;
        }
        field(76434; "NCF Credito fiscal NCR resg."; Code[20])
        {
            Description = 'DsPOS Guatemala,#116527';
            TableRelation = "No. Series";

            trigger OnValidate()
            var
                lrConf: Record "Configuracion General DsPOS";
            /*                 lcGuatemala: Codeunit "Funciones DsPOS - Guatemala"; */
            begin
                //+#232158
                //...
                /*
                
                //+116527
                //... De momento se restringe sólo al caso de Guatemala
                IF lrConf.FINDFIRST THEN
                  IF lrConf.Pais = lrConf.Pais::Guatemala THEN
                    IF lcGuatemala.TestSeriesResguardo(Tienda,"Id TPV") THEN
                      VALIDATE("NCF Credito fiscal NCR","NCF Credito fiscal NCR resg.");
                
                */
                //-#232158

            end;
        }
        field(76435; "Leyenda Dosificacion"; Text[150])
        {
            Caption = 'Leyenda Dosificación';
            Description = 'DsPOS Bolivia';
        }
        field(76436; "NCF Credito fiscal 2"; Code[20])
        {
            Description = '#325138,DsPOS El Salvador';
            TableRelation = "No. Series";
        }
        field(76429; "NCF Credito fiscal NCR 2"; Code[20])
        {
            Description = '#325138,DsPOS El Salvador';
            TableRelation = "No. Series";
        }
        field(76437; "Texto aviso FE"; Text[250])
        {
            Description = 'DsPOS Guatemala';
        }
    }

    keys
    {
        key(Key1; Tienda, "Id TPV")
        {
            Clustered = true;
        }
        key(Key2; Tienda, "Usuario windows")
        {
        }
        key(Key3; "Menu de acciones", "Menu de Formas de Pago", "Menu de productos")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Tienda, "Id TPV", Descripcion)
        {
        }
    }

    trigger OnInsert()
    begin
        TestField("Id TPV");
        TestField(Tienda);
    end;

    var
        Error001: Label 'There is not Windows Login %1';


    procedure CompruebaMenu(pTipo: Option ,Acciones,Pagos,Productos; pID: Code[10])
    var
        rMenu: Record "Menus TPV";
    begin

        rMenu.Reset;
        rMenu.SetCurrentKey("Tipo Menu");
        rMenu.SetRange("Tipo Menu", pTipo);
        rMenu.SetRange(rMenu."Menu ID", pID);
        if rMenu.FindFirst then begin
            rMenu.CalcFields("Cantidad de botones");
            rMenu.TestField("Cantidad de botones");
        end;
    end;
}

