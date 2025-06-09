pageextension 50038 pageextension50038 extends "Item Card"
{
    layout
    {
        modify("No.")
        {
            Editable = wEditaMDM;
        }
        modify("Base Unit of Measure")
        {
            Editable = wEditaMDM;
        }
        modify("Item Category Code")
        {
            Editable = wEditaMDM;
        }
        modify(InventoryNonFoundation)
        {
            ToolTip = 'Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.';
        }
        modify("Qty. on Purch. Order")
        {
            ToolTip = 'Specifies how many units of the item are inbound on purchase orders, meaning listed on outstanding purchase order lines.';
        }
        modify("Qty. on Sales Order")
        {
            ToolTip = 'Specifies how many units of the item are allocated to sales orders, meaning listed on outstanding sales orders lines.';
        }
        modify("Qty. on Job Order")
        {
            ToolTip = 'Specifies how many units of the item are allocated to jobs, meaning listed on outstanding job planning lines.';
        }
        modify("Costing Method")
        {
            Editable = wEditaMDM;
        }
        modify("Standard Cost")
        {
            ToolTip = 'Specifies the unit cost that is used as an estimation to be adjusted with variances later. It is typically used in assembly and production where costs can vary.';
        }
        modify("Unit Cost")
        {
            ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
        }
        modify("Indirect Cost %")
        {
            ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
        }
        modify("VAT Prod. Posting Group")
        {
            ToolTip = 'Specifies the Tax specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the Tax posting setup.';
        }
        modify("Tax Group Code")
        {
            ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
        }
        modify("Tariff No.")
        {
            ToolTip = 'Specifies a code for the item''s tariff number.';
        }
        modify("Unit Price")
        {
            ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
        }
        modify("Price Includes VAT")
        {
            ToolTip = 'Specifies if the Unit Price and Line Amount fields on sales document lines for this item should be shown with or without tax.';
        }
        modify("Price/Profit Calculation")
        {
            ToolTip = 'Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this item.';
        }
        modify("Profit %")
        {
            ToolTip = 'Specifies the profit margin that you want to sell the item at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field';
        }
        modify("Allow Invoice Disc.")
        {
            ToolTip = 'Specifies if the item should be included in the calculation of an invoice discount on documents where the item is traded.';
        }
        modify("Item Disc. Group")
        {
            ToolTip = 'Specifies an item group code that can be used as a criterion to grant a discount when the item is sold to a certain customer.';
        }
        modify("Sales Unit of Measure")
        {
            ToolTip = 'Specifies the unit of measure code used when you sell the item.';
        }
        modify("Sales Blocked")
        {
            ToolTip = 'Specifies that the item cannot be entered on sales documents, except return orders and credit memos, and journals.';
        }
        modify("Lead Time Calculation")
        {
            ToolTip = 'Specifies a date formula for the amount of time it takes to replenish the item.';
        }
        modify("Purch. Unit of Measure")
        {
            ToolTip = 'Specifies the unit of measure code used when you purchase the item.';
        }
        modify("Flushing Method")
        {
            ToolTip = 'Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.';
        }
        /*modify(Control8) //No existe el campo validar en Nav
        {
            ToolTip = 'Specifies if the item is an assembly BOM.';
        }*/
        modify("Warehouse Class Code")
        {
            ToolTip = 'Specifies the warehouse class code for the item.';
        }
        modify("Special Equipment Code")
        {
            ToolTip = 'Specifies the code of the equipment that warehouse employees must use when handling the item.';
        }
        modify("Put-away Unit of Measure Code")
        {
            ToolTip = 'Specifies the code of the item unit of measure in which the program will put the item away.';
        }
        modify("Last Phys. Invt. Date")
        {
            ToolTip = 'Specifies the date on which you last posted the results of a physical inventory for the item to the item ledger.';
        }
        modify("Next Counting Start Date")
        {
            ToolTip = 'Specifies the starting date of the next counting period.';
        }
        modify("Identifier Code")
        {
            ToolTip = 'Specifies a unique code for the item in terms that are useful for automatic data capture.';
        }
        modify(Description)
        {
            Editable = wEditaMDM;
        }
        modify("Description 2")
        {
            Editable = wEditaMDM;
        }
        // modify("SAT Hazardous Material")
        // {
        //     Visible = false;
        // }
        // modify("SAT Packaging Type")
        // {
        //     Visible = false;
        // }
        addafter("No.")
        {
            field("No. 2"; rec."No. 2")
            {
                ApplicationArea = All;
                Caption = 'No. 2';
                Editable = false;
                RowSpan = 2;
            }
        }
        moveafter("No. 2"; Description, "Description 2")
        addafter("Search Description")
        {
            field("Activo Fijo Prototipo"; rec."Activo Fijo Prototipo")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(PreventNegInventoryDefaultNo)
        {
            field("Gestionado MdM"; rec."Gestionado MdM")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field(Inactivo; rec.Inactivo)
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Costs & Posting")
        {
            group("Required Fields Not completed")
            {
                Caption = 'Required Fields Not completed';
                Editable = false;
                Visible = false;
                field("vCamReq[1]"; vCamReq[1])
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
                field("vCamReq[2]"; vCamReq[2])
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
                field("vCamReq[3]"; vCamReq[3])
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
                field("vCamReq[4]"; vCamReq[4])
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
                field("vCamReq[5]"; vCamReq[5])
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
                field("vCamReq[6]"; vCamReq[6])
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
                field("vCamReq[7]"; vCamReq[7])
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
                field("vCamReq[8]"; vCamReq[8])
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
                field("vCamReq[9]"; vCamReq[9])
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
                field("vCamReq[10]"; vCamReq[10])
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
                field("vCamReq[11]"; vCamReq[11])
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
                field("vCamReq[12]"; vCamReq[12])
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    ShowCaption = false;
                }
            }
            group("Required Dimensions not completed")
            {
                Caption = 'Required Dimensions not completed';
                Editable = false;
                Visible = false;
                field("vDimReq[1]"; vDimReq[1])
                {
                    ApplicationArea = All;
                    //BlankZero = true;
                    Editable = true;
                }
                field("vDimReq[2]"; vDimReq[2])
                {
                    ApplicationArea = All;
                    //BlankZero = true;
                    Editable = true;
                }
                field("vDimReq[3]"; vDimReq[3])
                {
                    ApplicationArea = All;
                    //BlankZero = true;
                    Enabled = false;
                }
                field("vDimReq[4]"; vDimReq[4])
                {
                    ApplicationArea = All;
                    //BlankZero = true;
                    Editable = false;
                }
                field("vDimReq[5]"; vDimReq[5])
                {
                    ApplicationArea = All;
                    //BlankZero = true;
                    Editable = false;
                }
                field("vDimReq[6]"; vDimReq[6])
                {
                    ApplicationArea = All;
                    //BlankZero = true;
                    Editable = false;
                }
                field("vDimReq[7]"; vDimReq[7])
                {
                    ApplicationArea = All;
                    //BlankZero = true;
                    Editable = false;
                }
                field("vDimReq[8]"; vDimReq[8])
                {
                    ApplicationArea = All;
                    //BlankZero = true;
                    Editable = false;
                }
            }
        }
        addafter(Planning)
        {
            group(MdM)
            {
                Caption = 'MdM';
                Editable = wEditaMDM;
                group(Control1000000098)
                {
                    ShowCaption = false;
                    field(ISBN; rec.ISBN)
                    {
                        ApplicationArea = All;
                        RowSpan = 2;
                    }
                    field("cFunMdM.GetEAN(Rec)"; cFunMdM.GetEAN(Rec))
                    {
                        ApplicationArea = All;
                        Caption = 'EAN';
                        RowSpan = 2;
                    }
                    field("No. Paginas"; rec."No. Paginas")
                    {
                        ApplicationArea = All;
                    }
                    field("Derecho de autor"; rec."Derecho de autor")
                    {
                        ApplicationArea = All;
                    }
                    grid(Control1000000093)
                    {
                        Caption = 'Linea';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field("Tipo Producto"; rec."Tipo Producto")
                        {
                            ApplicationArea = All;
                        }
                        field("Desc.Tipo Producto"; GetDatAuxDescrp(0, rec."Tipo Producto"))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000090)
                    {
                        ShowCaption = false;
                        field(Soporte; rec.Soporte)
                        {
                            ApplicationArea = All;
                            StyleExpr = TRUE;
                        }
                        field("Desc.Soporte del Producto"; GetDatAuxDescrp(1, rec.Soporte))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000087)
                    {
                        Caption = 'Soporte';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(Linea; rec.Linea)
                        {
                            ApplicationArea = All;
                        }
                        field("Desc.Linea de Negocio"; GetDatAuxDescrp(7, rec.Linea))
                        {
                            ApplicationArea = All;
                            Caption = 'Línea de Negocio';
                            ShowCaption = false;
                        }
                    }
                    grid("Seal/Brand")
                    {
                        Caption = 'Seal/Brand';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(Sello; rec.Sello)
                        {
                            ApplicationArea = All;
                            Caption = 'Seal/Brand';
                        }
                        field("Desc. Sello"; GetDatAuxDescrp(10, rec.Sello))
                        {
                            ApplicationArea = All;
                            Caption = 'Seal/Brand';
                            ShowCaption = false;
                        }
                    }
                    grid(Languaje)
                    {
                        Caption = 'Languaje';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(Idioma; rec.Idioma)
                        {
                            ApplicationArea = All;
                        }
                        field("Desc.Idioma"; cFunMdM.GetIdiomaDesc(Rec))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000078)
                    {
                        Caption = 'Serie';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(SerieMetodo; GetDimValue(0))
                        {
                            ApplicationArea = All;
                            Editable = false;

                            trigger OnAssistEdit()
                            begin
                                ShowDim(0);
                            end;
                        }
                        field("Desc.SerieMetodo"; GetDimValueName(0))
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    grid(Author)
                    {
                        Caption = 'Author';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(Autor; rec.Autor)
                        {
                            ApplicationArea = All;
                        }
                        field("Desc.Autor"; GetDatAuxDescrp(5, rec.Autor))
                        {
                            ApplicationArea = All;
                            Caption = 'Author';
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000072)
                    {
                        Caption = 'Empresa Editora';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field("Empresa Editora"; rec."Empresa Editora")
                        {
                            ApplicationArea = All;
                        }
                        field("Desc. Empresa Editora"; GetDatAuxDescrp(2, rec."Empresa Editora"))
                        {
                            ApplicationArea = All;
                            Caption = 'Empresa Editora';
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000069)
                    {
                        Caption = 'Plan Editorial';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field("Plan Editorial"; rec."Plan Editorial")
                        {
                            ApplicationArea = All;
                        }
                        field("GetDatAuxDescrp(4,""Plan Editorial"")"; GetDatAuxDescrp(4, rec."Plan Editorial"))
                        {
                            Caption = 'Plan Editorial';
                            ShowCaption = false;
                            applicationArea = Basic, Suite;
                        }
                    }
                    grid(Control1000000066)
                    {
                        Caption = 'Edición';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(Edicion; rec.Edicion)
                        {
                            ApplicationArea = All;
                        }
                        field("Desc.Cod. Edición"; GetDatAuxDescrp(11, rec.Edicion))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000063)
                    {
                        Caption = 'Campaña';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(Campana; rec.Campana)
                        {
                            ApplicationArea = All;
                        }
                        field("GetDatAuxDescrp(13,Campana)"; GetDatAuxDescrp(13, rec.Campana))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000060)
                    {
                        Caption = 'Destino';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(Destino; GetDimValue(1))
                        {
                            ApplicationArea = All;
                            Editable = false;

                            trigger OnAssistEdit()
                            begin
                                ShowDim(1);
                            end;
                        }
                        field("Desc.Destino"; GetDimValueName(1))
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000057)
                    {
                        Caption = 'Cuenta';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(Cuenta; GetDimValue(2))
                        {
                            ApplicationArea = All;
                            Editable = false;

                            trigger OnAssistEdit()
                            begin
                                ShowDim(2);
                            end;
                        }
                        field("Desc.Cuenta"; GetDimValueName(2))
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000054)
                    {
                        Caption = 'Estructura Analitica';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field("Estructura Analitica"; rec."Estructura Analitica")
                        {
                            ApplicationArea = All;
                        }
                        field("Desc.Estructura Analitica"; cFunMdM.GetEstrcturaAnaliticaDescr(Rec))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000051)
                    {
                        Caption = 'Estado';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(Estado; rec.Estado)
                        {
                            ApplicationArea = All;
                        }
                        field("Desc.Estado"; GetDatAuxDescrp(12, rec.Estado))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000048)
                    {
                        Caption = 'Tipo Texto';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field("Tipo Texto"; GetDimValue(3))
                        {
                            ApplicationArea = All;

                            trigger OnAssistEdit()
                            begin
                                ShowDim(3);
                            end;
                        }
                        field("Desc. Tipo Texto"; GetDimValueName(3))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000045)
                    {
                        Caption = 'Asignatura';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(Asignatura; rec.Asignatura)
                        {
                            ApplicationArea = All;
                        }
                        field("Desc.Asignatura"; GetDatAuxDescrp(8, rec.Asignatura))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000042)
                    {
                        Caption = 'Materia';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(Materia; GetDimValue(4))
                        {
                            ApplicationArea = All;
                            Caption = 'Materia';

                            trigger OnAssistEdit()
                            begin
                                ShowDim(4);
                            end;
                        }
                        field("Desc.Materia"; GetDimValueName(4))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000039)
                    {
                        Caption = 'Nivel';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(wNivel; wNivel)
                        {
                            ApplicationArea = All;
                            Caption = 'Level';
                            Editable = false;
                        }
                        field("GetDatAuxDescrp(3,wNivel)"; GetDatAuxDescrp(3, wNivel))
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000036)
                    {
                        Caption = 'Ciclo';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(wCiclo; wCiclo)
                        {
                            ApplicationArea = All;
                            Caption = 'Cycle';
                            Editable = false;
                        }
                        field("GetDatAuxDescrp(6,wCiclo)"; GetDatAuxDescrp(6, wCiclo))
                        {
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                    grid(Control1000000033)
                    {
                        Caption = 'Curso';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field("Nivel Escolar (Grado)"; rec."Nivel Escolar (Grado)")
                        {
                            ApplicationArea = All;

                            trigger OnValidate()
                            begin
                                GestGrado; // MdM
                            end;
                        }
                        field("Desc.NivelEscolar"; GetDatAuxDescrp(9, rec."Nivel Escolar (Grado)"))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000030)
                    {
                        Caption = 'Carga Horaria';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field("Carga Horaria"; GetDimValue(5))
                        {
                            ApplicationArea = All;
                            Caption = 'Carga Horaria';

                            trigger OnAssistEdit()
                            begin
                                ShowDim(5);
                            end;
                        }
                        field("Desc.Carga Horaria"; GetDimValueName(5))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000027)
                    {
                        Caption = 'Origen';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field(Origen; GetDimValue(6))
                        {
                            ApplicationArea = All;
                            Caption = 'Origen';

                            trigger OnAssistEdit()
                            begin
                                ShowDim(6);
                            end;
                        }
                        field("Desc.Origen"; GetDimValueName(6))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    grid(Control1000000024)
                    {
                        Caption = 'Grupo de Negocio';
                        GridLayout = Columns;
                        ShowCaption = false;
                        field("Grupo de Negocio"; rec."Grupo de Negocio")
                        {
                            ApplicationArea = All;
                            Caption = 'Business Group';
                        }
                        field("Desc.GrupoNegocio"; cFunMdM.GetDatosAuxDesc(23, rec."Grupo de Negocio"))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                }
            }
            group(Santillana)
            {
                Caption = 'Santillana';
                field("Componentes Producto"; rec."Componentes Producto")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Titulo; rec.Titulo)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Produccion; rec.Produccion)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("No. Deposito Legal"; rec."No. Deposito Legal")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Encuadernacion; rec.Encuadernacion)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Peso Portada"; rec."Peso Portada")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Peso Hoja"; rec."Peso Hoja")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Formato; rec.Formato)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Calidad; rec.Calidad)
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gramaje Hoja"; rec."Gramaje Hoja")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Gramaje Portada"; rec."Gramaje Portada")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sub Familia"; rec."Sub Familia")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("% Castigo Mantenimiento"; rec."% Castigo Mantenimiento")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("% Castigo Conquista"; rec."% Castigo Conquista")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("% Castigo Perdida"; rec."% Castigo Perdida")
                {
                    ApplicationArea = Basic, Suite;
                }
                group("Backorder Availability")
                {
                    Caption = 'Backorder Availability';
                    field("Qty. on Sales Order2"; rec."Qty. on Sales Order")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Reserved Qty. on Inventory"; rec."Reserved Qty. on Inventory")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field("Qty. on Pre Sales Order"; rec."Qty. on Pre Sales Order")
                    {
                        ApplicationArea = Basic, Suite;
                    }
                    field(Availibility; rec.Inventory - rec."Qty. on Sales Order" - rec."Reserved Qty. on Inventory" - rec."Qty. on Service Order" - rec."Qty. on Pre Sales Order" - rec."Trans. Ord. Shipment (Qty.)")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Availibility';
                    }
                }
            }
        }
        moveafter("Qty. on Pre Sales Order"; "Trans. Ord. Shipment (Qty.)")
        addafter("Use Cross-Docking")
        {
            group(Control1000000108)
            {
                Caption = 'Valores MdM';
                Editable = wEditaMDMAut;
                ShowCaption = false;
                field("Fecha Almacen"; rec."Fecha Almacen")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin

                        // MdM - #209115
                        cFunMdM.GestContrlFechasProd(Rec, 1, 0);
                    end;
                }
                field("Fecha Comercializacion"; rec."Fecha Comercializacion")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin

                        // MdM - #209115
                        cFunMdM.GestContrlFechasProd(Rec, 2, 0);
                    end;
                }
            }
        }
    }
    actions
    {
        modify(Identifiers)
        {
            ToolTip = 'View a unique identifier for each item that you want warehouse employees to keep track of within the warehouse when using handheld devices. The item identifier can include the item number, the variant code and the unit of measure.';
        }
        modify(Approve)
        {
            ToolTip = 'Approve the requested changes.';
        }
        modify(Comment)
        {
            ToolTip = 'View or add comments for the record.';
        }
        modify(CancelApprovalRequest)
        {
            ToolTip = 'Cancel the approval request.';
        }
        /*     modify(CreateFlow)
            {
                ToolTip = 'Create a new Flow from a list of relevant Flow templates.';
            } */
        modify("Item Reclassification Journal")
        {
            ToolTip = 'Change information on item ledger entries, such as dimensions, location codes, bin codes, and serial or lot numbers.';
        }
        modify("Item Tracing")
        {
            ToolTip = 'Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.';
        }
        // modify("Item Turnover")
        // {
        //     ToolTip = 'View a detailed account of item turnover by periods after you have set the relevant filters for location and variant.';
        // }
        modify("<Action110>")
        {
            ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';
        }
        modify(Variant)
        {
            ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';
        }
        /*modify(Timeline) //No existe la acción validar en nav
        {
            ToolTip = 'Get a graphical view of an item''s projected inventory based on future supply and demand events, with or without planning suggestions. The result is a graphical representation of the inventory profile.';
        }*/
        modify("T&urnover")
        {
            ToolTip = 'View a detailed account of item turnover by periods after you have set the relevant filters for location and variant.';
        }
        modify("Cost Shares")
        {
            ToolTip = 'View how the costs of underlying items in the BOM roll up to the parent item. The information is organized according to the BOM structure to reflect at which levels the individual costs apply. Each item level can be collapsed or expanded to obtain an overview or detailed view.';
        }
        modify("Calc. Unit Price")
        {
            ToolTip = 'Calculate the unit price based on the unit cost and the profit percentage.';
        }
        modify("&Bin Contents")
        {
            ToolTip = 'View the quantities of the item in each bin where it exists. You can see all the important parameters relating to bin content, and you can modify certain bin content parameters in this window.';
        }
        modify(Troubleshooting)
        {
            ToolTip = 'View or edit information about technical problems with a service item.';
        }
        modify("Resource Skills")
        {
            ToolTip = 'View the assignment of skills to resources, items, service item groups, and service items. You can use skill codes to allocate skilled resources to service items or items that need special skills for servicing.';
        }
    }

    var
        vCamReq: array[50] of Text[100];
        vDimReq: array[12] of Text[60];
        "****Santillana***": Integer;
        wEditaMDM: Boolean;
        wEditaMDMAut: Boolean;
        wCiclo: Code[10];
        wNivel: Code[10];
        wCodDim: Code[20];
        cFunMdM: Codeunit "Funciones MdM";

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        wEditaMDM := cFunMdM.GetEditableP(Rec, false); // MdM
        wEditaMDMAut := cFunMdM.GetEditableP(Rec, true); // MdM - Si el usuario está autorizado a modificar algunos campos
        GestGrado; // MdM
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        RefrescaCamposRequeridos; //001
        RefrescaDimensionesRequeridas; //001
    end;

    trigger OnDeleteRecord(): Boolean
    var
        lwEdit: Boolean;
    begin
        lwEdit := cFunMdM.GetEditableP(Rec, false);
        if not lwEdit then
            cFunMdM.SetEditableError(Rec.TableCaption);
        exit(lwEdit);
    end;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        wEditaMDM := cFunMdM.GetEditable; // MdM
    end;

    procedure RefrescaCamposRequeridos()
    var
        recCamposRequeridos: Record "Lin. Campos Req. Maestros";
        I: Integer;
        vCampoBuscado: Code[30];
        vCampoRec: Integer;
        recCliente: Record Customer;
        recRef: RecordRef;
        MyFieldRef: FieldRef;
    begin
        //#32000
        Clear(vCamReq);
        recRef.GetTable(Rec);

        recCamposRequeridos.Reset;
        recCamposRequeridos.SetRange("No. Tabla", 27);
        if recCamposRequeridos.FindFirst then begin
            repeat
                MyFieldRef := recRef.Field(recCamposRequeridos."No. Campo");
                if Format(MyFieldRef.Value) = '' then begin
                    I += 1;
                    vCamReq[I] := recCamposRequeridos."Nombre Campo";
                end;

            until recCamposRequeridos.Next = 0;
        end;
    end;

    procedure RefrescaDimensionesRequeridas()
    var
        recRef2: RecordRef;
        MyFieldRef2: FieldRef;
        recLinDimRequeridas: Record "Lin. Dimensiones Req.";
        recDimenProducto: Record "Default Dimension";
        I2: Integer;
    begin
        //#32000
        Clear(vDimReq);
        recRef2.GetTable(Rec);

        recLinDimRequeridas.Reset;
        recLinDimRequeridas.SetRange(recLinDimRequeridas."No. Tabla", 27);
        if recLinDimRequeridas.FindSet then begin
            repeat
                recDimenProducto.Reset;
                recDimenProducto.SetRange("Table ID", 27);
                recDimenProducto.SetRange("No.", rec."No.");
                recDimenProducto.SetRange("Dimension Code", recLinDimRequeridas."Cod. Dimension");
                if not recDimenProducto.FindSet then begin
                    I2 += 1;
                    vDimReq[I2] := recLinDimRequeridas."Cod. Dimension";
                end;
            until recLinDimRequeridas.Next = 0;

        end;
    end;

    procedure GetAutorName(): Text[70]
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(rec.Autor) then
            exit(Vendor.Name);
    end;

    procedure GetDatAuxDescrp(pwTipo: Integer; pwCode: Code[20]) wDesc: Text
    begin
        // GetDatAuxDescrp
        // Mdm Devuelve la descripción de un dato de la tabla Datos MdM

        wDesc := cFunMdM.GetDatDescrp(pwTipo, pwCode);
    end;

    local procedure GetDimValue(pwTipoDim: Integer): Code[20]
    begin
        // GetDimValue
        // Devuelve el valor de una dimension determinada

        exit(cFunMdM.GetDimValueT(rec."No.", pwTipoDim));
    end;

    local procedure GetDimValueName(pwTipoDim: Integer): Text
    begin
        // GetDimValueName
        // Devuelve el nombre de un valor de dimensión

        exit(cFunMdM.GetDimValueName(rec."No.", pwTipoDim));
    end;

    procedure ShowDim(pwTipoDim: Integer)
    begin
        // ShowDim

        cFunMdM.ShowDimT(Rec, pwTipoDim);
    end;

    procedure GestGrado()
    var
        lrDTsM: Record "Datos MDM";
    begin
        // GestGrado
        // MdM
        // Define los valores Ciclo y Nivel que No están en la tabla pero está derivados de Grado

        Clear(wCiclo);
        Clear(wNivel);

        if lrDTsM.Get(9, rec."Nivel Escolar (Grado)") then begin
            wCiclo := lrDTsM."Codigo Relacionado";
            if lrDTsM.Get(6, wCiclo) then
                wNivel := lrDTsM."Codigo Relacionado";
        end;
    end;
}

