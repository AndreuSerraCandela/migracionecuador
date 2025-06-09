page 56033 "Transfer Line FactBox"
{
    ApplicationArea = all;
    Caption = 'Transfer Line Details';
    PageType = CardPart;
    SourceTable = "Transfer Line";

    layout
    {
        area(content)
        {
            field("Item No."; rec."Item No.")
            {
                Caption = 'Item No.';
                Lookup = false;

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            //field("STRSUBSTNO('%1',SalesInfoPaneMgt.CalcAvailabilityTransLine(Rec))"; StrSubstNo('%1', SalesInfoPaneMgt.CalcAvailabilityTransLine(Rec)))
            field("STRSUBSTNO('%1',SalesInfoPaneMgt.CalcAvailabilityTransLine(Rec))"; AvailabilityTransLine)
            {
                Caption = 'Availability';
                DecimalPlaces = 2 : 0;
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                var
                    AvailabilityType: Option Date,Variant,Location;
                begin
                    rec.ItemAvailability(AvailabilityType);
                    CurrPage.Update(true);
                end;
            }
        }
    }

    actions
    {
    }

    var
        SalesHeader: Record "Sales Header";
        SalesPriceCalcMgt: Codeunit "Price Calculation - Undefined";
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management Ext";
        AvailabilityTransLine: Decimal;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        AvailabilityTransLine := SalesInfoPaneMgt.CalcAvailabilityTransLine(Rec);
    end;


    procedure ShowDetails()
    var
        Item: Record Item;
    begin
        /*
        IF Type = Type::Item THEN BEGIN
          Item.GET("No.");
          PAGE.RUN(PAGE::"Item Card",Item);
        END;
        */

    end;


    procedure ShowPrices()
    begin
        /*
        SalesHeader.GET("Document Type","Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader,Rec);
        */

    end;


    procedure ShowLineDisc()
    begin
        /*
        SalesHeader.GET("Document Type","Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader,Rec);        */

    end;
}

