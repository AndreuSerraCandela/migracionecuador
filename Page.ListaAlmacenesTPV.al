page 76073 "Lista Almacenes TPV"
{
    ApplicationArea = all;
    Caption = 'Location List';
    CardPageID = "Location Card";
    Editable = false;
    PageType = List;
    SourceTable = Location;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; rec.Code)
                {
                }
                field(Name; rec.Name)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Location")
            {
                Caption = '&Location';
                Image = Warehouse;
                action("Dimensiones Defecto ")
                {
                    Caption = '&Dimensiones Defecto';
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "Dimension Defecto Almacen";
                    RunPageLink = "Cod. Almacen" = FIELD(Code);
                }
                separator(Action7301)
                {
                }
                action("&Zones")
                {
                    Caption = '&Zones';
                    Image = Zones;
                    RunObject = Page Zones;
                    RunPageLink = "Location Code" = FIELD(Code);
                }
                action("&Bins")
                {
                    Caption = '&Bins';
                    Image = Bins;
                    RunObject = Page Bins;
                    RunPageLink = "Location Code" = FIELD(Code);
                }
            }
        }
        area(processing)
        {
            action("Create Warehouse location")
            {
                Caption = 'Create Warehouse location';
                Image = NewWarehouse;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Create Warehouse Location";
            }
        }
    }

    trigger OnInit()
    var
        /*   cfComunes: Codeunit "Funciones DsPOS - Comunes"; */
        Error001: Label 'Función Sólo Disponible en Servidor Central';
    begin

        /*        if not (cfComunes.EsCentral) then
                   Error(Error001); */
    end;


    procedure GetSelectionFilter(): Text
    var
        Loc: Record Location;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(Loc);
        exit(SelectionFilterManagement.GetSelectionFilterForLocation(Loc));
    end;
}

