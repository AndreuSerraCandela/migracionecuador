pageextension 50035 pageextension50035 extends "Vendor Card"
{

    //Unsupported feature: Property Insertion (Permissions) on ""Vendor Card"(Page 26)".

    layout
    {
        modify("Address 2")
        {
            ToolTip = 'Specifies additional address information.';

            //Unsupported feature: Property Modification (ImplicitType) on ""Address 2"(Control 8)".

        }

        //Unsupported feature: Property Modification (ImplicitType) on "City(Control 10)".

        modify(County)
        {
            ToolTip = 'Specifies the state, province or county as a part of the address.';
        }

        //Unsupported feature: Property Modification (ImplicitType) on ""Phone No."(Control 12)".

        modify("Tax Liable")
        {
            ToolTip = 'Specifies if the customer is liable for sales tax.';
        }
        modify("Tax Area Code")
        {
            ToolTip = 'Specifies a tax area code for the company.';
        }
        modify("Prices Including VAT")
        {
            ToolTip = 'Specifies if the Unit Price and Line Amount fields on document lines should be shown with or without tax.';
        }
        modify("Gen. Bus. Posting Group")
        {
            ToolTip = 'Specifies the vendor''s trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.';
        }
        modify("VAT Bus. Posting Group")
        {
            ToolTip = 'Specifies the Tax specification of the involved customer or vendor to link transactions made for this record with the appropriate general ledger account according to the Tax posting setup.';
        }
        modify("Application Method")
        {
            ToolTip = 'Specifies how to apply payments to entries for this vendor.';
        }
        modify("Shipment Method Code")
        {
            ToolTip = 'Specifies the delivery conditions of the related shipment, such as free on board (FOB).';
        }

        modify("EORI Number")
        {
            Visible = false;
        }
        addafter("Balance Due (LCY)")
        {
            field("Territory Code"; rec."Territory Code")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Disable Search by Name")
        {
            field("Proveedor Ocasional"; rec."Proveedor Ocasional")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Excluir Informe ATS"; rec."Excluir Informe ATS")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo Contribuyente"; rec."Tipo Contribuyente")
            {
                ApplicationArea = Basic, Suite;

                trigger OnValidate()
                begin
                    activateTipoContribExt;
                    //CurrPage.UPDATE;//#24482
                end;
            }
            field("Desc. Tipo Contribuyente"; rec."Desc. Tipo Contribuyente")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
            field("Tipo Contrib. Extranjero"; rec."Tipo Contrib. Extranjero")
            {
                ApplicationArea = Basic, Suite;
                Editable = wEditTipoContribExt;
            }
            field("Tipo Documento"; rec."Tipo Documento")
            {
                ApplicationArea = Basic, Suite;
                Editable = true;
                Visible = false;
            }
            field("Tipo Ruc/Cedula"; rec."Tipo Ruc/Cedula")
            {
                ApplicationArea = Basic, Suite;
            }

            field("Parte Relacionada"; rec."Parte Relacionada")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Inactivo; rec.Inactivo)
            {
                ApplicationArea = Basic, Suite;
            }
        }

        moveafter("Tipo Ruc/Cedula"; "VAT Registration No.")

        addafter("Address & Contact")
        {
            group("Required Fields No Completed")
            {
                Caption = 'Required Fields No Completed';
                Editable = false;
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
                Enabled = false;
                field("vDimReq[1]"; vDimReq[1])
                {
                    ApplicationArea = All;

                    Editable = true;
                }
                field("vDimReq[2]"; vDimReq[2])
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("vDimReq[3]"; vDimReq[3])
                {
                    ApplicationArea = All;

                    Enabled = false;
                }
                field("vDimReq[4]"; vDimReq[4])
                {
                    ApplicationArea = All;

                    Editable = false;
                }
                field("vDimReq[5]"; vDimReq[5])
                {
                    ApplicationArea = All;

                    Editable = false;
                }
                field("vDimReq[6]"; vDimReq[6])
                {
                    ApplicationArea = All;

                    Editable = false;
                }
                field("vDimReq[7]"; vDimReq[7])
                {
                    ApplicationArea = All;

                    Editable = false;
                }
                field("vDimReq[8]"; vDimReq[8])
                {
                    ApplicationArea = All;

                    Editable = false;
                }
            }
        }
        addafter("Vendor Posting Group")
        {
            field("Cod. Clasificacion Gasto"; rec."Cod. Clasificacion Gasto")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Insertion (RunObject) on "ContactBtn(Action 14)".


        //Unsupported feature: Property Insertion (RunPageView) on "ContactBtn(Action 14)".


        //Unsupported feature: Property Insertion (RunPageLink) on "ContactBtn(Action 14)".


        modify(Statistics)
        {
            ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
        }
        modify(NewBlanketPurchaseOrder)
        {
            Caption = 'Blanket Purchase Order';
            ToolTip = 'Create a new blanket purchase order for the vendor.';
        }
        modify(NewPurchaseOrder)
        {
            ToolTip = 'Create a new purchase order.';
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
        /*         modify(CreateFlow)
                {
                    ToolTip = 'Create a new Flow from a list of relevant Flow templates.';
                } */
        modify("Vendor - Balance to Date")
        {
            Caption = 'Vendor - Balance to Date';
        }
        // modify("Projected Cash Payments")
        // {
        //     ToolTip = 'View projections about what future payments to vendors will be. Current orders are used to generate a chart, using the specified time period and start date, to break down future payments. The report also includes a total balance column.';
        // }



        //Unsupported feature: Code Modification on "ContactBtn(Action 14).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ShowContact;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //001 ShowContact;
        */
        //end;
        addfirst("Ven&dor")
        {
            action(Retentions)
            {
                Caption = 'Retentions';
                Image = CalculateCost;
                ApplicationArea = All;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Page "Proveedor - Retencion";
                RunPageLink = "Cód. Proveedor" = FIELD("No.");
                RunPageView = SORTING("Cód. Proveedor", "Código Retención")
                              ORDER(Ascending);
                ShortCutKey = 'Shift+Ctrl+R';
            }
        }
        addafter(Attachments)
        {
            action("<Action1000000001>")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Retention';
                Promoted = true;
                RunObject = Page "Proveedor - Retencion";
                RunPageLink = "Cód. Proveedor" = FIELD("No.");
            }
            action("SRI Authorizations")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'SRI Authorizations';
                Promoted = true;
                RunObject = Page "Autorizaciones SRI Proveedores";
                RunPageLink = "Cod. Proveedor" = FIELD("No.");
            }
        }
    }

    var
        vCamReq: array[50] of Text[100];
        vDimReq: array[8] of Text[60];

        wEditTipoContribExt: Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CreateVendorFromTemplate;
    ActivateFields;
    OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
    #4..7

    if "No." <> '' then
      CurrPage.AgedAccPayableChart.PAGE.UpdateChartForVendor("No.");
    if GetFilter("Date Filter") = '' then
      SetRange("Date Filter",0D,WorkDate);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..10
    */
    //end;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ActivateFields;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ActivateFields;

    RefrescaCamposRequeridos; //001
    RefrescaDimensionesRequeridas; //001
    */
    //end;

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
        recCamposRequeridos.SetRange("No. Tabla", 23);
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
        recLinDimRequeridas.SetRange(recLinDimRequeridas."No. Tabla", 23);
        if recLinDimRequeridas.FindSet then begin
            repeat
                recDimenProducto.Reset;
                recDimenProducto.SetRange("Table ID", 23);
                recDimenProducto.SetRange("No.", rec."No.");
                recDimenProducto.SetRange("Dimension Code", recLinDimRequeridas."Cod. Dimension");
                if not recDimenProducto.FindSet then begin
                    I2 += 1;
                    vDimReq[I2] := recLinDimRequeridas."Cod. Dimension";
                end;
            until recLinDimRequeridas.Next = 0;

        end;

    end;

    procedure activateTipoContribExt()
    begin
        //wEditTipoContribExt := (("Tipo Contribuyente" = 'EX') OR ("Tipo Contribuyente" = 'EX RUC'));
        wEditTipoContribExt := (rec."Tipo Contribuyente" = 'EX');
    end;
}

