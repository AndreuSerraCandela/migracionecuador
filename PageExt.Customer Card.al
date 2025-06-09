pageextension 50029 pageextension50029 extends "Customer Card"
{
    layout
    {
        modify(Name)
        {
            ToolTip = 'Specifies the customer''s name. This name will appear on all sales documents for the customer. You can enter a maximum of 50 characters, both numbers and letters.';
        }
        modify("Search Name")
        {
            Importance = Standard;
            Visible = false;
        }
        // modify("CFDI Customer Name")
        // {
        //     ShowMandatory = false;
        //     Visible = false;
        // }
        modify("Address 2")
        {
            ToolTip = 'Specifies additional address information.';
        }
        modify(City)
        {
            ToolTip = 'Specifies the customer''s city.';
        }
        modify(County)
        {
            ToolTip = 'Specifies the state, province or county as a part of the address.';
            Caption = 'State / ZIP Code';
            Editable = false;
        }
        moveafter(County; ShowMap)

        modify("E-Mail")
        {
            ToolTip = 'Specifies the customer''s email address.';
        }
        modify("Tax Liable")
        {
            ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
        }
        modify("Tax Area Code")
        {
            ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';
        }
        modify("Customer Disc. Group")
        {
            ToolTip = 'Specifies the customer discount group code, which you can use as a criterion to set up special discounts in the Sales Line Discounts window.';
        }
        modify("Allow Line Disc.")
        {
            ToolTip = 'Specifies if a sales line discount is calculated when a special sales price is offered according to setup in the Sales Prices window.';
        }
        modify("Prices Including VAT")
        {
            ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without tax.';
        }
        modify("Application Method")
        {
            ToolTip = 'Specifies how to apply payments to entries for this customer.';
        }
        modify("Print Statements")
        {
            ToolTip = 'Specifies whether to include this customer when you print the Statement report.';
        }
        // modify("Check Date Format")
        // {
        //     ToolTip = 'Specifies how the date will appear on the printed check image for this bank account.';
        // }
        modify("Shipment Method Code")
        {
            ToolTip = 'Specifies which shipment method to use when you ship items to the customer.';
        }
        modify("Balance (LCY)2")
        {
            ToolTip = 'Specifies the payment amount that the customer owes for completed sales. This value is also known as the customer''s balance.';
        }
        modify("Balance Due")
        {
            CaptionClass = Format(StrSubstNo(OverduePaymentsMsg, Format(WorkDate)));
        }
        /*modify(GetAmountOnPostedInvoices) //nuevo campos validar y traer funcionalidad de nav
        {
            ToolTip = 'Specifies your sales to the customer in the current fiscal year based on posted sales invoices. The figure in parenthesis Specifies the number of posted sales invoices.';
        }
        modify(GetAmountOnCrMemo)
        {
            ToolTip = 'Specifies your expected refunds to the customer in the current fiscal year based on posted sales credit memos. The figure in parenthesis shows the number of posted sales credit memos.';
        }
        modify(GetAmountOnOutstandingInvoices)
        {
            ToolTip = 'Specifies your expected sales to the customer in the current fiscal year based on ongoing sales invoices. The figure in parenthesis shows the number of ongoing sales invoices.';
        }*/
        modify("IC Partner Code")
        {
            Visible = false;
        }
        // modify("CFDI Export Code")
        // {
        //     Visible = false;
        // }
        // modify("SAT Tax Regime Classification")
        // {
        //     Visible = false;
        // }
        modify("EORI Number")
        {
            Visible = false;
        }
        addafter("Salesperson Code")
        {
            field("Collector Code"; rec."Collector Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo Documento"; rec."Tipo Documento")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;

                trigger OnValidate()
                begin
                    CurrPage.Update;
                end;
            }
            field("Tipo Ruc/Cedula"; rec."Tipo Ruc/Cedula")
            {
                ApplicationArea = Basic, Suite;

                trigger OnValidate()
                begin
                    CurrPage.Update;
                end;
            }
        }
        moveafter("Tipo Ruc/Cedula"; "VAT Registration No.")
        addafter("Disable Search by Name")
        {
            field("Saldo provision"; rec."Saldo provision")
            {
                ApplicationArea = All;
            }
            field("Saldo general"; rec.Balance - rec."Saldo provision")
            {
                ApplicationArea = All;
            }
            field("Exento Provision"; rec."Exento Provision")
            {
                ApplicationArea = All;
            }
            field("Parte Relacionada"; rec."Parte Relacionada")
            {
                ApplicationArea = All;
            }
            field(Inactivo; rec.Inactivo)
            {
                ApplicationArea = All;
            }
            field("Fecha inicio relacion"; rec."Fecha inicio relacion")
            {
                ApplicationArea = All;
            }
            field("Calificacion de cliente"; rec."Calificacion de cliente")
            {
                ApplicationArea = All;
            }
            field(Sexo; rec.Sexo)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Estado Civil"; rec."Estado Civil")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Origen Ingresos"; rec."Origen Ingresos")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Bloqueo de Facturar Desde"; rec."Bloqueo de Facturar Desde")
            {
                ApplicationArea = All;
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Admite Pendientes en Pedidos"; rec."Admite Pendientes en Pedidos")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Permite venta a credito"; rec."Permite venta a credito")
                {
                    ApplicationArea = All;
                }
                field("Colegio por defecto POS"; rec."Colegio por defecto POS")
                {
                    ApplicationArea = All;
                }
            }
        }

        moveafter(City; "Post Code")

        addafter(City)
        {
            field("Territory Code"; rec."Territory Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Phone No.")
        {
            field("No. Telefono Envio"; rec."No. Telefono Envio")
            {
                ApplicationArea = All;
            }
        }
        addafter("Address & Contact")
        {
            group("Campos Requeridos no completados")
            {
                Caption = 'Campos Requeridos no completados';
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
            group("Dimensiones Requeridas no Completadas")
            {
                Caption = 'Dimensiones Requeridas no Completadas';
                Enabled = false;
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
        // addafter("Tax Identification Type")
        // {
        //     field("Tipo de Venta2"; rec."Tipo de Venta")
        //     {
        //     ApplicationArea = All;
        //     }
        // }
        addafter("Shipping Advice")
        {
            field("Packing requerido"; rec."Packing requerido")
            {
                ApplicationArea = All;
            }
        }
        addafter(Shipping)
        {
            group("Consignación")
            {
                Caption = 'Consignación';
                field("Cod. Almacen Consignacion"; rec."Cod. Almacen Consignacion")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Balance en Consignacion"; rec."Balance en Consignacion")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Inventario en Consignacion"; rec."Inventario en Consignacion")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Prioridad entrega consignacion"; rec."Prioridad entrega consignacion")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Tipo de Venta"; rec."Tipo de Venta")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Code2"; rec."Shipping Agent Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        modify(Action76)
        {
            ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
        }
        modify("Issued &Finance Charge Memos")
        {
            ToolTip = 'View the finance charge memos that you have sent to the customer.';
        }
        modify(NewBlanketSalesOrder)
        {
            ToolTip = 'Create a blanket sales order for the customer.';
        }
        modify(NewSalesQuote)
        {
            ToolTip = 'Offer items or services to a customer.';
        }
        modify(NewSalesQuoteAddin)
        {
            ToolTip = 'Offer items or services to a customer.';
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
        /*       modify(CreateFlow)
              {
                  ToolTip = 'Create a new Flow from a list of relevant Flow templates.';
              } */
        // modify("Account Detail")
        // {
        //     ToolTip = 'View the detailed account activity for each customer for any period of time. The report lists all activity with running account balances, or only open items or only closed items with totals of either. The report can also show the application of payments to invoices.';
        // }
        // modify("Cash Applied")
        // {
        //     ToolTip = 'View how the cash received from customers has been applied to documents. The report includes the number of the document and type of document to which the payment has been applied.';
        // }
        modify("Report Statement")
        {
            ToolTip = 'View a list of a customer''s transactions for a selected period, for example, to send to the customer at the close of an accounting period. You can choose to have all overdue balances displayed regardless of the period specified, or you can choose to include an aging band.';
        }
        addafter("Sales Journal")
        {
            separator(Action1000000023)
            {
            }
            action("<Action1000000011>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Consignment Location';
                Image = ReceiveLoaner;
                InFooterBar = true;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ConfSant: Record "Config. Empresa";
                    Loc: Record Location;
                    InvPostSet: Record "Inventory Posting Setup";
                    txt003: Label 'The location code %1 had been create for customer %2';
                begin
                    //001
                    Loc.Init;
                    Loc.Validate(Code, rec."No.");
                    Loc.Validate(Name, rec.Name);
                    Loc.Validate(Address, rec.Address);
                    Loc.Validate(City, rec.City);
                    Loc.Validate("Phone No.", rec."Phone No.");
                    Loc.Validate("Fax No.", rec."Fax No.");
                    Loc.Validate("Cod. Cliente", rec."No.");
                    if Loc.Insert then;

                    rec."Cod. Almacen Consignacion" := rec."No.";
                    rec.Modify;
                    Commit;

                    ParamEc.Reset;
                    ParamEc.FindSet;
                    repeat
                        InvPostSet.Init;
                        InvPostSet.Validate("Location Code", rec."No.");
                        InvPostSet.Validate("Invt. Posting Group Code", ParamEc."Grupo Contable Exist.");
                        InvPostSet.Validate("Inventory Account", ParamEc."Cod. Cuenta");
                        InvPostSet.Insert(true);
                    until ParamEc.Next = 0;

                    Message(txt003, rec."Cod. Almacen Consignacion", rec."No.");
                    //001
                end;
            }
        }
    }

    var
        vCamReq: array[50] of Text[100];
        vDimReq: array[12] of Text[60];
        ParamEc: Record "Grpo. Exist. Consig. Defecto";
        ParamEc1: Record "Grpo. Exist. Consig. Defecto";
        OverduePaymentsMsg: Label 'Overdue Payments as of %1'; //ESM=Pagos vencidos al %1;FRC=Paiements échus au %1;ENC=Overdue Payments as of %1

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        RefrescaCamposRequeridos;       //001
        RefrescaDimensionesRequeridas;  //001
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
        //001
        Clear(vCamReq);
        recRef.GetTable(Rec);

        recCamposRequeridos.Reset;
        recCamposRequeridos.SetRange("No. Tabla", 18);
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
        recDimenCliente: Record "Default Dimension";
        I2: Integer;
    begin
        //001
        Clear(vDimReq);
        recRef2.GetTable(recDimenCliente);

        recLinDimRequeridas.Reset;
        recLinDimRequeridas.SetRange(recLinDimRequeridas."No. Tabla", 18);
        if recLinDimRequeridas.FindSet then begin
            repeat
                recDimenCliente.Reset;
                recDimenCliente.SetRange(recDimenCliente."Table ID", 18);
                recDimenCliente.SetRange(recDimenCliente."No.", rec."No.");
                recDimenCliente.SetRange(recDimenCliente."Dimension Code", recLinDimRequeridas."Cod. Dimension");
                if not recDimenCliente.FindSet then begin
                    I2 += 1;
                    vDimReq[I2] := recLinDimRequeridas."Cod. Dimension";
                end;
            until recLinDimRequeridas.Next = 0;

        end;

    end;
}

