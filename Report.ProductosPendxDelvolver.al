report 56534 "Productos Pend x Delvolver"
{
    // 
    // ---------------------------------
    // YFC     : Yefrecis Cruz
    // ------------------------------------------------------------------------
    // No.         Firma     Fecha            Descripcion
    // ------------------------------------------------------------------------
    // 001         YFC      27/4/2020        SANTINAV-936
    DefaultLayout = RDLC;
    RDLCLayout = './ProductosPendxDelvolver.rdlc';


    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            column(PostingDate_SalesInvoiceHeader; "Sales Invoice Header"."Posting Date")
            {
            }
            column(No_SalesInvoiceHeader; "Sales Invoice Header"."No.")
            {
            }
            column(SelltoCustomerNo_SalesInvoiceHeader; "Sales Invoice Header"."Sell-to Customer No.")
            {
            }
            column(CodProducto; CodProducto)
            {
            }
            column(CodCliente; CodCliente)
            {
            }
            column(NoDocumento; NoDocumento)
            {
            }
            column(FechaDesde; FechaDesde)
            {
            }
            column(FechaHasta; FechaHasta)
            {
            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(Quantity_SalesInvoiceLine; "Sales Invoice Line".Quantity)
                {
                }
                column(LocationCode_SalesInvoiceLine; "Sales Invoice Line"."Location Code")
                {
                }
                column(Description_SalesInvoiceLine; "Sales Invoice Line".Description)
                {
                }
                column(CantidadDevuelta_SalesInvoiceLine; "Sales Invoice Line"."Cantidad Devuelta")
                {
                }
                column(No_SalesInvoiceLine; "Sales Invoice Line"."No.")
                {
                }
                column(PostingDate_SalesInvoiceLine; "Sales Invoice Line"."Posting Date")
                {
                }
                column(SelltoCustomerNo_SalesInvoiceLine; "Sales Invoice Line"."Sell-to Customer No.")
                {
                }
                column(DocumentNo_SalesInvoiceLine; "Sales Invoice Line"."Document No.")
                {
                }
                column(Cantidad; recMovProd."Shipped Qty. Not Returned")
                {
                }

                trigger OnAfterGetRecord()
                begin

                    recMovValor.Reset;
                    recMovValor.SetCurrentKey("Document No.");
                    recMovValor.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                    recMovValor.SetRange("Document Type", recMovValor."Document Type"::"Sales Invoice");
                    recMovValor.SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
                    if recMovValor.FindFirst then begin
                        recMovProd.Reset;
                        recMovProd.SetRange("Entry No.", recMovValor."Item Ledger Entry No.");
                        recMovProd.SetFilter("Shipped Qty. Not Returned", '<>%1', 0);
                        if recMovProd.FindFirst then;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if CodProducto <> '' then
                        "Sales Invoice Line".SetFilter("No.", CodProducto);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                /*
                IF CodProducto  <> '' THEN
                  BEGIN
                    SIL.reset;
                    SIL.SETRANGE(SIL."Document No.","Sales Invoice Header"."No.");
                    IF SIL.FINDFIRST THEN
                      CurrReport.SKIP;
                  END
                */

            end;

            trigger OnPreDataItem()
            begin
                if NoDocumento <> '' then
                    "Sales Invoice Header".SetFilter("No.", NoDocumento);

                if CodCliente <> '' then
                    SetFilter("Sell-to Customer No.", CodCliente);

                if (FechaDesde <> 0D) and (FechaHasta <> 0D) then
                    SetRange("Posting Date", FechaDesde, FechaHasta);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Opciones)
                {
                    field(CodProducto; CodProducto)
                    {
                        TableRelation = Item;
                        ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
                    }
                    field(CodCliente; CodCliente)
                    {
                        TableRelation = Customer;
                        ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
                    }
                    field(NoDocumento; NoDocumento)
                    {
                        TableRelation = "Sales Invoice Header";
                        ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
                    }
                    field(FechaDesde; FechaDesde)
                    {
                        Caption = 'FechaRegistro';
                        ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
                    }
                    field(FechaHasta; FechaHasta)
                    {
                        ApplicationArea = Basic, Suite; // Se agrega ApplicationArea
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CodProducto: Code[20];
        CodCliente: Code[20];
        NoDocumento: Code[20];
        FechaDesde: Date;
        FechaHasta: Date;
        SIL: Record "Sales Invoice Line";
        recMovValor: Record "Value Entry";
        recMovProd: Record "Item Ledger Entry";
}