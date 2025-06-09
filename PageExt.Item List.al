pageextension 50041 pageextension50041 extends "Item List"
{
    layout
    {
        modify(Description)
        {
            ToolTip = 'Specifies a description of the item.';
        }
        modify("Price/Profit Calculation")
        {
            ToolTip = 'Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this item.';
        }
        modify("Profit %")
        {
            ToolTip = 'Specifies the profit margin that you want to sell the item at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field';
        }
        modify("Item Disc. Group")
        {
            Visible = true;
            ToolTip = 'Specifies an item group code that can be used as a criterion to grant a discount when the item is sold to a certain customer.';
        }
        modify("Tariff No.")
        {
            ToolTip = 'Specifies a code for the item''s tariff number.';
        }
        modify("Indirect Cost %")
        {
            ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
        }
        modify(Blocked)
        {
            Visible = true;
            ToolTip = 'Specifies that transactions with the item cannot be posted, for example, because the item is in quarantine.';
        }
        modify("Purch. Unit of Measure")
        {
            ToolTip = 'Specifies the unit of measure code used when you purchase the item.';
        }
        modify("Flushing Method")
        {
            ToolTip = 'Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.';
        }
        modify("Default Deferral Template Code")
        {
            ToolTip = 'Specifies the default template that governs how to defer revenues and expenses to the periods when they occurred.';
        }
        modify("Inventory Posting Group")
        {
            Visible = true;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = true;
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
        modify("Item Category Code")
        {
            Visible = true;
        }
        addafter("No.")
        {
            field("No. 2"; rec."No. 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("Unit Price")
        {
            field("VAT Bus. Posting Gr. (Price)"; rec."VAT Bus. Posting Gr. (Price)")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter(Blocked)
        {
            field("Tipo Producto"; rec."Tipo Producto")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Soporte; rec.Soporte)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Linea; rec.Linea)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Estado; rec.Estado)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Asignatura; rec.Asignatura)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Nivel Escolar (Grado)"; rec."Nivel Escolar (Grado)")
            {
                ApplicationArea = Basic, Suite;
            }
            field(wNivel; wNivel)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Nivel';
                Editable = false;
                Importance = Additional;
            }
            field(wCiclo; wCiclo)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ciclo';
                Editable = false;
                Importance = Additional;
            }
            field(ISBN; rec.ISBN)
            {
                ApplicationArea = Basic, Suite;
            }
            field(EAN; rec.EAN)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'EAN';
                RowSpan = 2;
            }
            field("Grupo de Negocio"; rec."Grupo de Negocio")
            {
                ApplicationArea = Basic, Suite;
            }
            field(wPrecio; wPrecio)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Precio Venta';
            }
            field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Default Deferral Template Code")
        {
            /*field("Product Group Code"; "Product Group Code") //No existe el campo validar en nav
            {
            }*/
            field("<Destino>"; GetDimValue(1))
            {
                Caption = '<Destino>';
                Editable = false;
                ApplicationArea = Basic, Suite;

                trigger OnAssistEdit()
                begin
                    ShowDim(1);//001+-
                end;
            }
            field("<Desc.Destino>"; GetDimValueName(1))
            {
                Caption = '<Desc.Destino>';
                Editable = false;
                ShowCaption = true;
                ApplicationArea = Basic, Suite;
            }
        }
    }
    actions
    {
        modify("&Units of Measure")
        {
            ToolTip = 'Set up the different units that the item can be traded in, such as piece, box, or hour.';
        }
        modify("Va&riants")
        {
            ToolTip = 'View how the inventory level of an item will develop over time according to the variant that you select.';
        }
        modify(DimensionsMultiple)
        {
            ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';
        }
        modify("&Value Entries")
        {
            ToolTip = 'View the history of posted amounts that affect the value of the item. Value entries are created for every transaction with the item.';
        }
        modify("&Warehouse Entries")
        {
            ToolTip = 'View the history of quantities that are registered for the item in warehouse activities. ';
        }
        modify("Adjust Cost - Item Entries")
        {
            Caption = 'Adjust Cost - Item Entries';
            ToolTip = 'Adjust inventory values in value entries so that you use the correct adjusted cost for updating the general ledger and so that sales and profit statistics are up to date.';
        }
        modify("Post Inventory Cost to G/L")
        {
            Caption = 'Post Inventory Cost to G/L';
            ToolTip = 'Post the quantity and value changes to the inventory in the item ledger entries and the value entries when you post inventory transactions, such as sales shipments or purchase receipts.';
        }
        modify("Physical Inventory Journal")
        {
            ToolTip = 'Select how you want to maintain an up-to-date record of your inventory at different locations.';
        }
        modify(CancelApprovalRequest)
        {
            ToolTip = 'Cancel the approval request.';
        }
        modify("Item Journal")
        {
            ToolTip = 'Open a list of journals where you can adjust the physical quantity of items on inventory.';
        }
        modify("Item Reclassification Journal")
        {
            ToolTip = 'Change information on item ledger entries, such as dimensions, location codes, bin codes, and serial or lot numbers.';
        }
        modify("Item Tracing")
        {
            ToolTip = 'Trace where a lot or serial number assigned to the item was used, for example, to find which lot a defective component came from or to find all the customers that have received items containing the defective component.';
        }
        modify("Assemble to Order - Sales")
        {
            Caption = 'Assemble to Order - Sales';
        }
        modify("Inventory Valuation - WIP")
        {
            ToolTip = 'View inventory valuation for selected production orders in your WIP inventory. The report also shows information about the value of consumption, capacity usage and output in WIP. The printed report only shows invoiced amounts, that is, the cost of entries that have been posted as invoiced.';
        }
        modify("Inventory - List")
        {
            ToolTip = 'View various information about the item, such as name, unit of measure, posting group, shelf number, vendor''s item number, lead time calculation, minimum inventory, and alternate item number. You can also see if the item is blocked.';
        }
        modify("Inventory Cost and Price List")
        {
            Caption = 'Inventory Cost and Price List';
        }
        modify("Inventory Availability")
        {
            ToolTip = 'View, print, or save a summary of historical inventory transactions with selected items, for example, to decide when to purchase the items. The report specifies quantity on sales order, quantity on purchase order, back orders from vendors, minimum inventory, and whether there are reorders.';
        }
        modify("Inventory - Cost Variance")
        {
            Caption = 'Inventory - Cost Variance';
        }
        modify("Invt. Valuation - Cost Spec.")
        {
            Caption = 'Invt. Valuation - Cost Spec.';
        }
        modify("Compare List")
        {
            ToolTip = 'View a comparison of components for two items. The printout compares the components, their unit cost, cost share and cost per component.';
        }
        // modify("Item Turnover")
        // {
        //     ToolTip = 'View a detailed account of item turnover by periods after you have set the relevant filters for location and variant.';
        // }
        modify("Item Age Composition - Value")
        {
            Caption = 'Item Age Composition - Value';
        }
        modify("Inventory - Vendor Purchases")
        {
            ToolTip = 'View a list of the vendors that your company has purchased items from within a selected period. It shows invoiced quantity, amount and discount. The report can be used to analyze a company''s item purchases.';
        }
        // modify("Back Order Fill by Item")
        // {
        //     Caption = 'Back Order Fill by Item';
        // }
        // modify("Purchase Advice")
        // {
        //     ToolTip = 'Get suggestions on what items you need to order to keep inventory at the desired level. This report looks at sales and purchase orders as well as backorders to determine the reorder amount.';
        // }
        modify("<Action5>")
        {
            ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';
        }
        modify(Variant)
        {
            ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';
        }
        /*modify(Timeline) //nueva acción validar y traer funcionalidad de nav
        {
            ToolTip = 'Get a graphical view of an item''s projected inventory based on future supply and demand events, with or without planning suggestions. The result is a graphical representation of the inventory profile.';
        }*/
        modify(Structure)
        {
            ToolTip = 'View which child items are used in an item''s assembly BOM or production BOM. Each item level can be collapsed or expanded to obtain an overview or detailed view.';
        }
        modify("Cost Shares")
        {
            ToolTip = 'View how the costs of underlying items in the BOM roll up to the parent item. The information is organized according to the BOM structure to reflect at which levels the individual costs apply. Each item level can be collapsed or expanded to obtain an overview or detailed view.';
        }
        modify("T&urnover")
        {
            ToolTip = 'View a detailed account of item turnover by periods after you have set the relevant filters for location and variant.';
        }

        modify("Ca&talog Items")
        {
            ToolTip = 'View the list of items that you do not carry in inventory. ';
        }
        modify(Troubleshooting)
        {
            ToolTip = 'View or edit information about technical problems with a service item.';
        }
        modify("Resource &Skills")
        {
            ToolTip = 'View the assignment of skills to resources, items, service item groups, and service items. You can use skill codes to allocate skilled resources to service items or items that need special skills for servicing.';
        }
    }

    var
        cFunMdM: Codeunit "Funciones MdM";
        wCiclo: Code[10];
        wNivel: Code[10];
        wPrecio: Decimal;
        rSalesPrice: Record "Price List Line"; // Cambio de tabla Sales Price

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //+
        GestGrado; // MdM

        rSalesPrice.Reset;
        rSalesPrice.SetRange("Asset Type", rSalesPrice."Asset Type"::Item);
        rSalesPrice.SetRange("Product No.", Rec."No.");
        if rSalesPrice.FindLast then
            wPrecio := rSalesPrice."Unit Price"
        else
            wPrecio := 0;
        //-
    end;


    procedure GetDatAuxDescrp(pwTipo: Integer; pwCode: Code[20]) wDesc: Text
    begin
        // GetDatAuxDescrp
        // Mdm Devuelve la descripción de un dato de la tabla Datos MdM

        wDesc := cFunMdM.GetDatDescrp(pwTipo, pwCode);
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

    local procedure GetDimValue(pwTipoDim: Integer): Code[20]
    begin
        // GetDimValue
        // Devuelve el valor de una dimension determinada

        exit(cFunMdM.GetDimValueT(rec."No.", pwTipoDim));
    end;

    procedure ShowDim(pwTipoDim: Integer)
    begin
        // ShowDim

        cFunMdM.ShowDimT(Rec, pwTipoDim);
    end;

    local procedure GetDimValueName(pwTipoDim: Integer): Text
    begin
        // GetDimValueName
        // Devuelve el nombre de un valor de dimensión

        exit(cFunMdM.GetDimValueName(rec."No.", pwTipoDim));
    end;
}

