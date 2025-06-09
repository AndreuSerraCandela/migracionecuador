tableextension 50039 tableextension50039 extends Item
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 5)".

        modify(Blocked)
        {
            Description = 'CampReq1.01';
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Inventory(Field 68)".

        modify("Qty. on Purch. Order")
        {
            Caption = 'Qty. on Purch. Order';
        }
        modify("VAT Bus. Posting Gr. (Price)")
        {
            Caption = 'Tax Bus. Posting Gr. (Price)';
        }
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("Country/Region of Origin Code")
        {
            TableRelation = "Country/Region" WHERE(Bloqueado = CONST(false));
        }
        modify("VAT Prod. Posting Group")
        {
            Caption = 'VAT Prod. Posting Group';
        }
        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Last Unit Cost Calc. Date")
        {
            Caption = 'Last Unit Cost Calc. Date';
        }
        modify("Item Category Code")
        {
            TableRelation = "Item Category" WHERE(Bloqueado = CONST(false));
        }
        modify("Planned Order Receipt (Qty.)")
        {
            Caption = 'Planned Order Receipt (Qty.)';
        }
        modify("Purch. Req. Receipt (Qty.)")
        {
            Caption = 'Purch. Req. Receipt (Qty.)';
        }
        modify("Purch. Req. Release (Qty.)")
        {
            Caption = 'Purch. Req. Release (Qty.)';
        }
        modify("Qty. on Component Lines")
        {
            Caption = 'Qty. on Component Lines';
        }

        //Unsupported feature: Code Modification on "Description(Field 3).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if ("Search Description" = UpperCase(xRec.Description)) or ("Search Description" = '') then
          "Search Description" := CopyStr(Description,1,MaxStrLen("Search Description"));

        if "Created From Nonstock Item" then begin
          NonstockItem.SetCurrentKey("Item No.");
        #6..9
              NonstockItem.Modify;
            end;
        end;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        // MdM No debemos de cambiar el titulo corto en la validación de la descripción. 11/11/17
        {
        IF ("Search Description" = UPPERCASE(xRec.Description)) OR ("Search Description" = '') THEN
          "Search Description" := COPYSTR(Description,1,MAXSTRLEN("Search Description"));
        }
        #3..12
        */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on "Blocked(Field 54).OnValidate".

        //trigger (Variable: UserSetup)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on "Blocked(Field 54).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if not Blocked then
          "Block Reason" := '';
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        if not Blocked then
          "Block Reason" := '';

        //002++
        if UserSetup.Get(UserId) then begin
          if Blocked = false then
            if not UserSetup."Desbloquea Productos" then
              Error(Text100)
            else begin
              ValidaCampReq.Maestros(27,"No.");
              ValidaCampReq.Dimensiones(27,"No.",0,0);
            end;
        end
        else
         Error(Text100);
        //002--
        */
        //end;


        //Unsupported feature: Code Modification on ""Price Includes VAT"(Field 87).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if "Price Includes VAT" then begin
          SalesSetup.Get;
          SalesSetup.TestField("VAT Bus. Posting Gr. (Price)");
          "VAT Bus. Posting Gr. (Price)" := SalesSetup."VAT Bus. Posting Gr. (Price)";
          VATPostingSetup.Get("VAT Bus. Posting Gr. (Price)","VAT Prod. Posting Group");
        end;
        Validate("Price/Profit Calculation");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        if "Price Includes VAT" then begin
          SalesSetup.Get;
          if SalesSetup."VAT Bus. Posting Gr. (Price)" <> '' then
            "VAT Bus. Posting Gr. (Price)" := SalesSetup."VAT Bus. Posting Gr. (Price)";
        #5..7
        */
        //end;


        //Unsupported feature: Code Modification on ""Item Category Code"(Field 5702).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        if not IsTemporary then
          ItemAttributeManagement.InheritAttributesFromItemCategory(Rec,"Item Category Code",xRec."Item Category Code");
        UpdateItemCategoryId;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..3

        //+
        if "Item Category Code" <> xRec."Item Category Code" then begin
          if ItemCategory.Get("Item Category Code") then begin
            if "Gen. Prod. Posting Group" = '' then
              Validate("Gen. Prod. Posting Group",ItemCategory."Def. Gen. Prod. Posting Group");
            if ("VAT Prod. Posting Group" = '') or
               (GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") and
                ("Gen. Prod. Posting Group" = ItemCategory."Def. Gen. Prod. Posting Group") and
                ("VAT Prod. Posting Group" = GenProdPostingGrp."Def. VAT Prod. Posting Group"))
            then
              Validate("VAT Prod. Posting Group",ItemCategory."Def. VAT Prod. Posting Group");
            if "Inventory Posting Group" = '' then
              Validate("Inventory Posting Group",ItemCategory."Def. Inventory Posting Group");
            if "Tax Group Code" = '' then
              Validate("Tax Group Code",ItemCategory."Def. Tax Group Code");
            Validate("Costing Method",ItemCategory."Def. Costing Method");
          end;

          //fes mig
          {
          IF NOT ProductGrp.GET("Item Category Code","Product Group Code") THEN
            VALIDATE("Product Group Code",'')
          ELSE
            VALIDATE("Product Group Code");
          }
          //fes mig

          // + MdM
          "Gestionado MdM" := ItemCategory.MdM;
          // - MdM
        end;
        //-
        */
        //end;

        //Unsupported feature: Deletion (FieldCollection) on ""SAT Hazardous Material"(Field 27024)".


        //Unsupported feature: Deletion (FieldCollection) on ""SAT Packaging Type"(Field 27025)".

        field(50000; "No. Paginas"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 0;
        }
        field(50001; "Componentes Producto"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Componentes Prod.";
        }
        field(50002; ISBN; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Qty. on Pre Sales Order"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST("Pre Order"),
                                                                            Type = CONST(Item),
                                                                            "No." = FIELD("No."),
                                                                            "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                            "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                            "Location Code" = FIELD("Location Filter"),
                                                                            "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                            "Variant Code" = FIELD("Variant Filter"),
                                                                            "Shipment Date" = FIELD("Date Filter")));
            Caption = 'Qty. on Pre Sales Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Nivel Escolar (Grado)"; Code[20])
        {
            Caption = 'Curso';
            DataClassification = ToBeClassified;
            TableRelation = "Datos MDM".Codigo WHERE(Tipo = CONST(Grado),
                                                      Bloqueado = CONST(false));
        }
        field(50007; "Carga horaria"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = "Carga Horaria";
        }
        field(50008; "Tipo Ingles"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            OptionCaption = ' ,USA,England';
            OptionMembers = " ",USA,England;
        }
        field(50009; Catalogo; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; Formato; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Libro," Cuaderno"," Guia"," Otros";
        }
        field(53000; "Id. reporte etiqueta"; Integer)
        {
            Caption = 'Label report Id.';
            DataClassification = ToBeClassified;
            /*             TableRelation = Object.ID WHERE(Type = CONST(Report)); */
        }
        field(56000; Inactivo; Boolean)
        {
            Caption = 'Inactivo';
            DataClassification = ToBeClassified;
            Description = '#7314,#37937,#34448';

            trigger OnValidate()
            var
                lErrorPermisos: Label 'No dispone de los permisos necesarios para Activar/Desactivar el producto.';
                lrAlmacen: Record Location;
                lErrorInventario: Label 'No es posible Inactivar el producto debido a que en el almacen %1 tiene inventario.';
                txt001_: Label 'You can not disable the product because it has much in Sales Orders / Purchase';
                UserSetup: Record "User Setup";
            begin
                //+001
                //#7314:Inicio
                if not (UserSetup.Get(UserId) and UserSetup."Activa/Inactiva Maestros") then
                    Error(lErrorPermisos);
                //#7314:Final

                //#37937:Inicio
                lrAlmacen.Reset;
                if lrAlmacen.Findset(false) then
                    repeat
                        "Location Filter" := lrAlmacen.Code;
                        CalcFields(Inventory);
                        if Inventory <> 0 then
                            Error(lErrorInventario, lrAlmacen.Code);
                    until lrAlmacen.Next = 0;
                //#37937

                //#34448 ++
                if Inactivo then begin
                    CalcFields("Qty. on Purch. Order");
                    CalcFields("Qty. on Sales Order");
                    if ("Qty. on Purch. Order" <> 0) or ("Qty. on Sales Order" <> 0) then
                        Error(txt001_);
                end;
                //#34448 --
            end;
        }
        field(56005; "Nivel Educativo"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Nivel Educativo APS";
        }
        field(56006; Tipos; Code[20])
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            TableRelation = Tipos;
        }
        field(56007; Edicion; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'MdM';
            TableRelation = "Datos MDM".Codigo WHERE(Tipo = CONST(Edicion),
                                                      Bloqueado = CONST(false));
        }
        field(56008; Estado; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'MdM';
            TableRelation = "Datos MDM".Codigo WHERE(Tipo = CONST(Estado),
                                                      Bloqueado = CONST(false));

            trigger OnValidate()
            begin
                // JPT 08/01/2019 Gestionamos el campo Inactivo a través del estado
                cFunMdM.SetEstadoProd(Rec);
            end;
        }
        field(56009; Obra; Text[50])
        {
            Caption = 'Play';
            DataClassification = ToBeClassified;
            Description = 'DerAut 1.0';
        }
        field(56010; Sello; Code[20])
        {
            Caption = 'Seal/Brand';
            DataClassification = ToBeClassified;
            Description = 'DerAut 1.0,MdM';
            TableRelation = "Datos MDM".Codigo WHERE(Tipo = CONST(Sello),
                                                      Bloqueado = CONST(false));
        }
        field(56011; "Tipo Edicion"; Code[20])
        {
            Caption = 'Type Edition';
            DataClassification = ToBeClassified;
            Description = 'DerAut 1.0';
            TableRelation = "Tipo Edicion";
        }
        field(56012; Titulo; Code[20])
        {
            Caption = 'Title';
            DataClassification = ToBeClassified;
            Description = 'DerAut 1.0';
        }
        field(56013; Idioma; Code[20])
        {
            Caption = 'Languaje';
            DataClassification = ToBeClassified;
            Description = 'DerAut 1.0';
            TableRelation = Language WHERE(Bloqueado = CONST(false));
        }
        field(56014; "Activo Fijo Prototipo"; Code[20])
        {
            Caption = 'Fixed Asset Prototype';
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset";
        }
        field(56015; Autor; Code[20])
        {
            Caption = 'Author';
            DataClassification = ToBeClassified;
            Description = 'DerAut 1.0, MdM';
            TableRelation = "Datos MDM".Codigo WHERE(Tipo = CONST(Autor),
                                                      Bloqueado = CONST(false));
        }
        field(56016; "Sub Familia"; Code[20])
        {
            Caption = 'Sub Family';
            DataClassification = ToBeClassified;
            Description = 'APS';

            trigger OnLookup()
            var
                DimVal: Record "Dimension Value";
                SubFam: Page "Dimension Value List";
            begin
                if ConfAPS.Get() then begin
                    DimVal.Reset;
                    DimVal.SetRange("Dimension Code", ConfAPS."Cod. Dimension Sub Familia");
                    DimVal.SetRange("Dimension Value Type", 0); //Estandar
                    SubFam.SetTableView(DimVal);
                    SubFam.SetRecord(DimVal);
                    SubFam.LookupMode(true);
                    if SubFam.RunModal = ACTION::LookupOK then begin
                        SubFam.GetRecord(DimVal);
                        "Sub Familia" := DimVal.Code;
                    end;
                    Clear(SubFam);
                end;
            end;
        }
        field(56017; "Derecho de autor"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'DerAut 1.0';
        }
        field(56018; "% Castigo Mantenimiento"; Decimal)
        {
            Caption = 'Penalty % Keeping';
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(56019; "% Castigo Conquista"; Decimal)
        {
            Caption = 'Penalty % Conquest';
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(56020; "% Castigo Perdida"; Decimal)
        {
            Caption = 'Penalty % Loosing';
            DataClassification = ToBeClassified;
            Description = 'APS';
        }
        field(56021; Materia; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST(Materia));

            trigger OnLookup()
            var
                Materia: Page Materias;
            begin
                DA.Reset;
                DA.SetRange("Tipo registro", DA."Tipo registro"::Materia);
                Materia.SetTableView(DA);
                Materia.SetRecord(DA);
                Materia.LookupMode(true);
                if Materia.RunModal = ACTION::LookupOK then begin
                    Materia.GetRecord(DA);
                    rec.Validate(Materia, DA.Codigo);
                end;

                Clear(Materia);
            end;

            trigger OnValidate()
            begin
                if Materia <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::Materia);
                    DA.SetRange(Codigo, Materia);
                    DA.FindFirst;
                    if xRec.Materia <> Materia then begin
                        //         IF CONFIRM(STRSUBSTNO(Text34002800,TABLECAPTION),FALSE) THEN
                        ActualizaDatosAPS(FieldNo(Materia));
                    end;

                end;
            end;
        }
        field(56022; "Grupo de Negocio"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'APS';
            TableRelation = "Datos auxiliares".Codigo WHERE("Tipo registro" = CONST("Grupo de Negocio"));

            trigger OnLookup()
            var
                GpoNegocio: Page "Grupos de Negocio";
            begin
                DA.Reset;
                DA.SetRange("Tipo registro", DA."Tipo registro"::"Grupo de Negocio");
                GpoNegocio.SetTableView(DA);
                GpoNegocio.SetRecord(DA);
                GpoNegocio.LookupMode(true);
                if GpoNegocio.RunModal = ACTION::LookupOK then begin
                    GpoNegocio.GetRecord(DA);
                    Validate("Grupo de Negocio", DA.Codigo);
                end;

                Clear(Materia);
            end;

            trigger OnValidate()
            begin
                if "Grupo de Negocio" <> '' then begin
                    DA.Reset;
                    DA.SetRange("Tipo registro", DA."Tipo registro"::"Grupo de Negocio");
                    DA.SetRange(Codigo, "Grupo de Negocio");
                    DA.FindFirst;
                    if xRec."Grupo de Negocio" <> "Grupo de Negocio" then begin
                        //         IF CONFIRM(STRSUBSTNO(Text34002800,TABLECAPTION),FALSE) THEN
                        ActualizaDatosAPS(FieldNo("Grupo de Negocio"));
                    end;
                end;
            end;
        }
        field(56026; Calidad; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(56027; "Gramaje Hoja"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(56028; "Gramaje Portada"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(56029; "Formato Dimension"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(56030; Produccion; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(56031; "No. Deposito Legal"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(56032; Encuadernacion; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(56033; "Peso Portada"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(56034; "Peso Hoja"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(56035; "Tipo de Peso"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ITPV';
        }
        field(56036; "linea-impresora"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ITPV';
        }
        field(56037; "Source counter"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ITPV';
        }
        field(56038; "Venta por internet"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ITPV';
        }
        field(75000; "Gestionado MdM"; Boolean)
        {
            Caption = 'Gestionado MdM';
            DataClassification = ToBeClassified;
            Description = 'MdM';
        }
        field(75001; "Tipo Producto"; Code[10])
        {
            Caption = 'Tipo Producto';
            DataClassification = ToBeClassified;
            Description = 'MdM';
            TableRelation = "Datos MDM".Codigo WHERE(Tipo = CONST("Tipo Producto"),
                                                      Bloqueado = CONST(false));
        }
        field(75002; Soporte; Code[10])
        {
            Caption = 'Soporte';
            DataClassification = ToBeClassified;
            Description = 'MdM';
            TableRelation = "Datos MDM".Codigo WHERE(Tipo = CONST(Soporte),
                                                      Bloqueado = CONST(false));
        }
        field(75003; "Empresa Editora"; Code[10])
        {
            Caption = 'Empresa Editora';
            DataClassification = ToBeClassified;
            Description = 'MdM';
            TableRelation = "Datos MDM".Codigo WHERE(Tipo = CONST(Editora),
                                                      Bloqueado = CONST(false));
        }
        field(75004; Linea; Code[10])
        {
            Caption = 'Linea';
            DataClassification = ToBeClassified;
            Description = 'MdM';
            TableRelation = "Datos MDM".Codigo WHERE(Tipo = CONST(Linea),
                                                      Bloqueado = CONST(false));
        }
        field(75005; Sociedad; Code[10])
        {
            Caption = 'Sociedad';
            DataClassification = ToBeClassified;
            Description = 'MdM';
            TableRelation = "Datos MDM".Codigo WHERE(Tipo = CONST(Editora),
                                                      Bloqueado = CONST(false));
        }
        field(75006; "Plan Editorial"; Code[10])
        {
            Caption = 'Plan Editorial';
            DataClassification = ToBeClassified;
            Description = 'MdM';
            TableRelation = "Datos MDM".Codigo WHERE(Tipo = CONST("Plan Editorial"),
                                                      Bloqueado = CONST(false));
        }
        field(75007; "Estructura Analitica"; Code[21])
        {
            Caption = 'Estructura Analitica';
            DataClassification = ToBeClassified;
            Description = 'MdM';
            TableRelation = "Estructura Analitica".Codigo WHERE(Blocked = CONST(false));
        }
        field(75008; "Fecha Almacen"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'MdM';

            trigger OnValidate()
            var
                lrBoomC: Record "BOM Component";
                lrProd2: Record Item;
            begin
                // MdM #209115 JPT 04/04/2019

                if "Fecha Almacen" <> 0D then begin
                    if not "Assembly BOM" then
                        CalcFields("Assembly BOM");
                    if "Assembly BOM" then begin
                        Clear(lrBoomC);
                        lrBoomC.SetRange("Parent Item No.", "No.");
                        lrBoomC.SetRange(Type, lrBoomC.Type::Item);
                        if lrBoomC.FindSet then begin
                            repeat
                                if lrProd2.Get(lrBoomC."No.") then begin
                                    if lrProd2."Fecha Almacen" = 0D then begin
                                        lrProd2."Fecha Almacen" := "Fecha Almacen";
                                        lrProd2.Modify(true);
                                    end;
                                end;
                            until lrBoomC.Next = 0;
                        end;
                    end;
                end;
            end;
        }
        field(75009; "Fecha Comercializacion"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'MdM';

            trigger OnValidate()
            var
                lrBoomC: Record "BOM Component";
                lrProd2: Record Item;
            begin
                // MdM #209115 JPT 04/04/2019

                if "Fecha Comercializacion" <> 0D then begin
                    if not "Assembly BOM" then
                        CalcFields("Assembly BOM");
                    if "Assembly BOM" then begin
                        Clear(lrBoomC);
                        lrBoomC.SetRange("Parent Item No.", "No.");
                        lrBoomC.SetRange(Type, lrBoomC.Type::Item);
                        if lrBoomC.FindSet then begin
                            repeat
                                if lrProd2.Get(lrBoomC."No.") then begin
                                    if lrProd2."Fecha Comercializacion" = 0D then begin
                                        lrProd2."Fecha Comercializacion" := "Fecha Comercializacion";
                                        lrProd2.Modify(true);
                                    end;
                                end;
                            until lrBoomC.Next = 0;
                        end;
                    end;
                end;
            end;
        }
        field(75010; Asignatura; Code[10])
        {
            Caption = 'Asignatura';
            DataClassification = ToBeClassified;
            Description = 'MdM';
            TableRelation = "Datos MDM".Codigo WHERE(Tipo = CONST(Asignatura),
                                                      Bloqueado = CONST(false));
        }
        field(75011; Campana; Code[10])
        {
            Caption = 'Campaña';
            DataClassification = ToBeClassified;
            Description = 'MdM';
            TableRelation = "Datos MDM".Codigo WHERE(Tipo = CONST("Campaña"),
                                                      Bloqueado = CONST(false));
        }
        field(75012; EAN; Code[50])
        {
            /*  CalcFormula = Lookup("Item Cross Reference"."Cross-Reference No." WHERE("Item No." = FIELD("No."),
                                                                                      "Cross-Reference Type" = CONST("Bar Code")));
             Caption = 'EAN';
             Description = 'MdM,FlowlField';
             Editable = false;
             FieldClass = FlowField; */
        }
    }
    keys
    {
        key(Key1; ISBN)
        {
        }
        key(KeyReports; "Item Category Code")
        {
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ApprovalsMgmt.OnCancelItemApprovalRequest(Rec);

    CheckJournalsAndWorksheets(0);
    #4..13
      until ServiceItem.Next = 0;

    DeleteRelatedData;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    // + MdM
    if not cFunMdM.GetEditableP(Rec,false) then
      cFunMdM.SetEditableError(TableCaption);
    // - MdM

    #1..16
    */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    if "No." = '' then begin
      GetInvtSetup;
      InvtSetup.TestField("Item Nos.");
    #4..8
      DATABASE::Item,"No.",
      "Global Dimension 1 Code","Global Dimension 2 Code");

    UpdateReferencedIds;
    SetLastDateTimeModified;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..11
    cFunMdM.GetDefDimesions(Rec); // MdM

    //001
    ConfEmpresa.Get();
    if ConfEmpresa."Productos nuevos bloqueados" then
      Blocked := true;
    //001

    UpdateReferencedIds;
    SetLastDateTimeModified;
    */
    //end;


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    UpdateReferencedIds;
    SetLastDateTimeModified;
    PlanningAssignment.ItemChange(Rec,xRec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3

    // MdM 18/09/17
    if not wModificadoMdM then
      cGestMdm.GestNotityProd(xRec, Rec);
    */
    //end;

    procedure ActualizaDatosAPS(IDCampo: Integer)
    var
        AdopcionesIn: Record "Colegio - Adopciones Detalle";
        AdopcionesOut: Record "Colegio - Adopciones Detalle";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        Msg001: Label 'Updating  #1########## @2@@@@@@@@@@@@@';
    begin
        exit; // Desactivosmo en el MdM JPT 18/12/18
        /*
        AdopcionesIn.RESET;
        AdopcionesIn.SETRANGE("Cod. Producto","No.");
        AdopcionesIn.SETFILTER(Adopcion,'<>%1',0);
        CounterTotal := AdopcionesIn.COUNT;
        Window.OPEN(Msg001);
        IF (IDCampo <> 50005) AND (IDCampo <> 56005) THEN
           BEGIN
            IF AdopcionesIn.FINDSET(TRUE,FALSE) THEN
               REPEAT
                 Counter += 1;
                 Window.UPDATE(1,"No.");
                 Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));
                 AdopcionesIn.Materia := Materia;
                 AdopcionesIn."Grupo de Negocio" := "Grupo de Negocio";
            //     adopcionesin.grado := grado;
        //         AdopcionesIn.VALIDATE(Adopcion);
                 AdopcionesIn.ActualizaAdopcion(Rec);
                 IF AdopcionesIn.MODIFY THEN;
               UNTIL AdopcionesIn.NEXT = 0;
           END
        ELSE
           BEGIN
            IF AdopcionesIn.FINDSET(TRUE,FALSE) THEN
               REPEAT
                 Counter += 1;
                 Window.UPDATE(1,"No.");
                 Window.UPDATE(2,ROUND(Counter / CounterTotal * 10000,1));
                 AdopcionesOut.COPY(AdopcionesIn);
                 AdopcionesOut."Cod. Nivel" := "Nivel Educativo";
                 AdopcionesOut."Cod. Grado" := "Nivel Escolar (Grado)";
                 AdopcionesIn.DELETE;
                 AdopcionesOut.INSERT;
               UNTIL AdopcionesIn.NEXT = 0;
        
           END;
        Window.CLOSE;
        MESSAGE(STRSUBSTNO(Text34002801,TABLECAPTION));
        */

    end;

    procedure GetLineaNegocio(): Code[20]
    var
        recCfgAPS: Record "Commercial Setup";
        recDefDim: Record "Default Dimension";
    begin
        recCfgAPS.Get;
        recCfgAPS.TestField("Cod. Dimension Lin. Negocio");

        recDefDim.Reset;
        recDefDim.SetRange("Table ID", 27);
        recDefDim.SetRange("No.", "No.");
        recDefDim.SetRange("Dimension Code", recCfgAPS."Cod. Dimension Lin. Negocio");
        if recDefDim.FindFirst then
            exit(recDefDim."Dimension Value Code");
    end;

    procedure GetFamilia(): Code[20]
    var
        recCfgAPS: Record "Commercial Setup";
        recDefDim: Record "Default Dimension";
    begin
        recCfgAPS.Get;
        recCfgAPS.TestField("Cod. Dimension Familia");

        recDefDim.Reset;
        recDefDim.SetRange("Table ID", 27);
        recDefDim.SetRange("No.", "No.");
        recDefDim.SetRange("Dimension Code", recCfgAPS."Cod. Dimension Familia");
        if recDefDim.FindFirst then
            exit(recDefDim."Dimension Value Code");
    end;

    procedure GetSubfamilia(): Code[20]
    var
        recCfgAPS: Record "Commercial Setup";
        recDefDim: Record "Default Dimension";
    begin
        recCfgAPS.Get;
        recCfgAPS.TestField("Cod. Dimension Sub Familia");

        recDefDim.Reset;
        recDefDim.SetRange("Table ID", 27);
        recDefDim.SetRange("No.", "No.");
        recDefDim.SetRange("Dimension Code", recCfgAPS."Cod. Dimension Sub Familia");
        if recDefDim.FindFirst then
            exit(recDefDim."Dimension Value Code");
    end;

    procedure SetModificadoMdM(prMod: Boolean)
    begin
        // SetModificadoMdM
        //  MdM Indicamos que ha sido modificado por MdM

        wModificadoMdM := prMod;
    end;

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".


    var
        //   UserSetup: Record "User Setup";
        ValidaCampReq: Codeunit "Valida Campos Requeridos";
        Text100: Label 'No tiene permiso para desbloquear productos';

    var
        ConfAPS: Record "Commercial Setup";
        DA: Record "Datos auxiliares";
        ConfEmpresa: Record "Config. Empresa";
        ConfSant: Record "Config. Empresa";
        ValidaCampos: Codeunit "Valida Campos Requeridos";
        rConfMdM: Record "Configuracion MDM";
        cGestMdm: Codeunit "Gest. Maestros MdM";
        cFunMdM: Codeunit "Funciones MdM";
        wModificadoMdM: Boolean;
        Texto016: Label 'User cannot unlock Items';
        Text34002800: Label 'You change some information in the %1, do you want to update the Adoptions data for the present Campaign?';
        Text34002801: Label 'The %1 information had been updated';
        ItemCategory: Record "Item Category";
}

