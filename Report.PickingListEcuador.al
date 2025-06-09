report 55022 "Picking List_Ecuador"
{
    // 
    // Proyecto: Microsoft Dynamics Nav
    // ------------------------------------------------------------------------------
    // FES   : Fausto Serrata
    // ------------------------------------------------------------------------------
    // No.                 Firma         Fecha           Descripción
    // ------------------------------------------------------------------------------
    // SANTINAV-351        FES           30-09-2019      Incluir codigo de barras producto
    //                                                   Insertar líneas entre las filas
    //                                                   Eliminar No. fila packing. No. Pallet.
    //                                                   Insertar imagen sello
    // 001 #3476           RRT           11.09.2014      Incluir la dirección del envío
    // #11350              MOI           03/02/2015      Se ha modificado la busqueda del usuario registrado.
    // 002                 FES           18-Mar-2021     SANTINAV-2267: Adicionar campo Colonia
    DefaultLayout = RDLC;
    RDLCLayout = './PickingListEcuador.rdlc';

    ApplicationArea = Basic, Suite;
    Caption = 'Picking List';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Warehouse Activity Header"; "Warehouse Activity Header")
        {
            DataItemTableView = WHERE(Type = FILTER(Pick | "Invt. Pick"));
            RequestFilterFields = "No.", "No. Printed";
            column(USERID; UserId)
            {
            }
            /*column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }*/
            column(TIME; Time)
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(FORMAT_TODAY_0_4_; Today)
            {
            }
            column(PickFilter; PickFilter)
            {
            }
            column(DirectedPutAwayAndPick; Location."Directed Put-away and Pick")
            {
            }
            column(BinMandatory; Location."Bin Mandatory")
            {
            }
            column(InvtPick; InvtPick)
            {
            }
            column(ShowLotSN; ShowLotSN)
            {
            }
            column(SumUpLines; SumUpLines)
            {
            }
            column(NombreCliente; UpperCase(NombreCliente))
            {
            }
            column(CodigoCliente; UpperCase(CodCliente) + ' - ' + UpperCase(NombreCliente))
            {
            }
            column(TipoVta; TipoVta)
            {
            }
            column(LocDir1; Location.Address)
            {
            }
            column(LocDir2; Location."Cod. Sucursal")
            {
            }
            column(NoEnvio; NoEnvio)
            {
            }
            column(CodUsAsig; UsuarioAsig)
            {
            }
            column(NombreUsAsig; NombreUsAsig)
            {
            }
            column(NoPicking; "Warehouse Activity Line"."No.")
            {
            }
            column(NoPedido; NoPedido)
            {
            }
            column(Observaciones; Comentario)
            {
            }
            column(FechaYHora; WorkDate)
            {
            }
            column(FechaDeLanzado; FechaLanzado)
            {
            }
            column(HoraDeLanzado; HoraLanzado)
            {
            }
            column(FechaDeEnvio; FechaEnvio)
            {
            }
            column(CodVendedor; CodVendedor)
            {
            }
            column(NombreVendedor; NombreVendedor)
            {
            }
            column(DireccionCliente; DirCliente)
            {
            }
            column(wDatosEnvio_1_; wDatosEnvio[1])
            {
            }
            column(wDatosEnvio_2_; wDatosEnvio[2])
            {
            }
            column(wDatosEnvio_3_; wDatosEnvio[3])
            {
            }
            column(wDatosEnvio_4_; wDatosEnvio[4])
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Picking_ListCaption; Picking_ListCaptionLbl)
            {
            }
            column(Tipo_Venta_Caption; Tipo_Venta_CaptionLbl)
            {
            }
            column(Cliente_LBL; Cliente_LBLLbl)
            {
            }
            column("Datos_envío_Caption"; Datos_envío_CaptionLbl)
            {
            }
            column(Warehouse_Activity_Header_Type; Type)
            {
            }
            column(Warehouse_Activity_Header_No_; "No.")
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                /*column(CurrReport_PAGENO_Control4; CurrReport.PageNo)
                {
                }*/
                column(COMPANYNAME_Control1; CompanyName)
                {
                }
                column(FORMAT_TODAY_0_4__Control6; Format(Today, 0, 4))
                {
                }
                column(TIME_Control75; Time)
                {
                }
                column(PickFilter_Control139; PickFilter)
                {
                }
                column(DirectedPutAwayAndPick_Control140; Location."Directed Put-away and Pick")
                {
                }
                column(BinMandatory_Control159; Location."Bin Mandatory")
                {
                }
                column(InvtPick_Control160; InvtPick)
                {
                }
                column(ShowLotSN_Control161; ShowLotSN)
                {
                }
                column(SumUpLines_Control162; SumUpLines)
                {
                }
                column(Warehouse_Activity_Header__TABLECAPTION__________PickFilter; "Warehouse Activity Header".TableCaption + ': ' + PickFilter)
                {
                }
                column(PickFilter_Control1480000; PickFilter)
                {
                }
                column(Warehouse_Activity_Header___Location_Code_; "Warehouse Activity Header"."Location Code")
                {
                }
                column(Warehouse_Activity_Header___No__; "Warehouse Activity Header"."No.")
                {
                }
                column(Warehouse_Activity_Header___Sorting_Method_; "Warehouse Activity Header"."Sorting Method")
                {
                }
                column(Warehouse_Activity_Header___Assigned_User_ID_; "Warehouse Activity Header"."Assigned User ID")
                {
                }
                column(Location__Bin_Mandatory_; Location."Bin Mandatory")
                {
                }
                column(Cod_almacen; Location.Code)
                {
                }
                column(InvtPick_Control1480003; InvtPick)
                {
                }
                column(CurrReport_PAGENO_Control4Caption; CurrReport_PAGENO_Control4CaptionLbl)
                {
                }
                column(Picking_ListCaption_Control5; Picking_ListCaption_Control5Lbl)
                {
                }
                column(Warehouse_Activity_Header___Location_Code_Caption; "Warehouse Activity Header".FieldCaption("Location Code"))
                {
                }
                column(Warehouse_Activity_Header___No__Caption; "Warehouse Activity Header".FieldCaption("No."))
                {
                }
                column(Warehouse_Activity_Header___Sorting_Method_Caption; "Warehouse Activity Header".FieldCaption("Sorting Method"))
                {
                }
                column(Warehouse_Activity_Header___Assigned_User_ID_Caption; "Warehouse Activity Header".FieldCaption("Assigned User ID"))
                {
                }
                column(WhseActLine__Unit_of_Measure_Code_Caption; WhseActLine__Unit_of_Measure_Code_CaptionLbl)
                {
                }
                column(WhseActLine__Qty__to_Handle_Caption; WhseActLine.FieldCaption("Qty. to Handle"))
                {
                }
                column(WhseActLine__Shelf_No__Caption; WhseActLine.FieldCaption("Shelf No."))
                {
                }
                column(WhseActLine_DescriptionCaption; WhseActLine.FieldCaption(Description))
                {
                }
                column(WhseActLine__Item_No__Caption; WhseActLine.FieldCaption("Item No."))
                {
                }
                column(WhseActLine__Source_No__Caption; WhseActLine.FieldCaption("Source No."))
                {
                }
                column(WhseActLine__Destination_No__Caption; WhseActLine.FieldCaption("Destination No."))
                {
                }
                column(Qty__HandledCaption; Qty__HandledCaptionLbl)
                {
                }
                column(WhseActLine__Unit_of_Measure_Code__Control51Caption; WhseActLine__Unit_of_Measure_Code__Control51CaptionLbl)
                {
                }
                column(WhseActLine__Qty__to_Handle__Control53Caption; WhseActLine.FieldCaption("Qty. to Handle"))
                {
                }
                column(WhseActLine__Zone_Code_Caption; WhseActLine.FieldCaption("Zone Code"))
                {
                }
                column(WhseActLine_Description_Control43Caption; WhseActLine.FieldCaption(Description))
                {
                }
                column(WhseActLine__Item_No___Control42Caption; WhseActLine.FieldCaption("Item No."))
                {
                }
                column(WhseActLine__Source_No___Control31Caption; WhseActLine.FieldCaption("Source No."))
                {
                }
                column(WhseActLine__Destination_No___Control57Caption; WhseActLine.FieldCaption("Destination No."))
                {
                }
                column(WhseActLine__Bin_Code_Caption; WhseActLine.FieldCaption("Bin Code"))
                {
                }
                column(Qty__HandledCaption_Control69; Qty__HandledCaption_Control69Lbl)
                {
                }
                column(Qty__HandledCaption_Control103; Qty__HandledCaption_Control103Lbl)
                {
                }
                column(WhseActLine__Unit_of_Measure_Code__Control86Caption; WhseActLine__Unit_of_Measure_Code__Control86CaptionLbl)
                {
                }
                column(WhseActLine__Qty__to_Handle__Control85Caption; WhseActLine.FieldCaption("Qty. to Handle"))
                {
                }
                column(WhseActLine__Shelf_No___Control83Caption; WhseActLine.FieldCaption("Shelf No."))
                {
                }
                column(WhseActLine_Description_Control78Caption; WhseActLine.FieldCaption(Description))
                {
                }
                column(WhseActLine__Item_No___Control77Caption; WhseActLine.FieldCaption("Item No."))
                {
                }
                column(WhseActLine__Destination_No___Control82Caption; WhseActLine.FieldCaption("Destination No."))
                {
                }
                column(WhseActLine__Source_No___Control73Caption; WhseActLine.FieldCaption("Source No."))
                {
                }
                column(Qty__HandledCaption_Control117; Qty__HandledCaption_Control117Lbl)
                {
                }
                column(WhseActLine__Unit_of_Measure_Code__Control89Caption; WhseActLine__Unit_of_Measure_Code__Control89CaptionLbl)
                {
                }
                column(WhseActLine__Qty__to_Handle__Control90Caption; WhseActLine.FieldCaption("Qty. to Handle"))
                {
                }
                column(WhseActLine__Bin_Code__Control92Caption; WhseActLine.FieldCaption("Bin Code"))
                {
                }
                column(WhseActLine_Description_Control95Caption; WhseActLine.FieldCaption(Description))
                {
                }
                column(WhseActLine__Item_No___Control96Caption; WhseActLine.FieldCaption("Item No."))
                {
                }
                column(WhseActLine__Destination_No___Control99Caption; WhseActLine.FieldCaption("Destination No."))
                {
                }
                column(WhseActLine__Source_No___Control101Caption; WhseActLine.FieldCaption("Source No."))
                {
                }
                column(Integer_Number; Number)
                {
                }
                dataitem("Warehouse Activity Line"; "Warehouse Activity Line")
                {
                    DataItemLink = "Activity Type" = FIELD(Type), "No." = FIELD("No.");
                    DataItemLinkReference = "Warehouse Activity Header";
                    DataItemTableView = SORTING("Activity Type", "No.", "Sorting Sequence No.") WHERE("Action Type" = FILTER(<> Place));

                    trigger OnAfterGetRecord()
                    begin
                        //AMS
                        if I = 0 then begin
                            if ("Source Document" = "Source Document"::"Sales Order") or
                               ("Source Document" = "Source Document"::"Outbound Transfer") then begin
                                I := 1;
                                NoPedido := "Source No.";
                            end;
                        end;

                        if SumUpLines and
                           ("Warehouse Activity Header"."Sorting Method" <>
                            "Warehouse Activity Header"."Sorting Method"::Document)
                        then begin
                            if TmpWhseActLine."No." = '' then begin
                                TmpWhseActLine := "Warehouse Activity Line";
                                TmpWhseActLine.Insert;
                                Mark(true);
                            end else begin
                                TmpWhseActLine.SetCurrentKey("Activity Type", "No.", "Bin Code", "Breakbulk No.", "Action Type");
                                TmpWhseActLine.SetRange("Activity Type", "Activity Type");
                                TmpWhseActLine.SetRange("No.", "No.");
                                TmpWhseActLine.SetRange("Bin Code", "Bin Code");
                                TmpWhseActLine.SetRange("Item No.", "Item No.");
                                TmpWhseActLine.SetRange("Action Type", "Action Type");
                                TmpWhseActLine.SetRange("Variant Code", "Variant Code");
                                TmpWhseActLine.SetRange("Unit of Measure Code", "Unit of Measure Code");
                                TmpWhseActLine.SetRange("Due Date", "Due Date");
                                if "Warehouse Activity Header"."Sorting Method" =
                                   "Warehouse Activity Header"."Sorting Method"::"Ship-To"
                                then begin
                                    TmpWhseActLine.SetRange("Destination Type", "Destination Type");
                                    TmpWhseActLine.SetRange("Destination No.", "Destination No.")
                                end;
                                if TmpWhseActLine.Find('-') then begin
                                    TmpWhseActLine."Qty. (Base)" := TmpWhseActLine."Qty. (Base)" + "Qty. (Base)";
                                    TmpWhseActLine."Qty. to Handle" := TmpWhseActLine."Qty. to Handle" + "Qty. to Handle";
                                    TmpWhseActLine."Source No." := '';
                                    if "Warehouse Activity Header"."Sorting Method" <>
                                       "Warehouse Activity Header"."Sorting Method"::"Ship-To"
                                    then begin
                                        TmpWhseActLine."Destination Type" := TmpWhseActLine."Destination Type"::" ";
                                        TmpWhseActLine."Destination No." := '';
                                    end;
                                    TmpWhseActLine.Modify;
                                end else begin
                                    TmpWhseActLine := "Warehouse Activity Line";
                                    TmpWhseActLine.Insert;
                                    Mark(true);
                                end;
                            end;
                        end else
                            Mark(true);
                    end;

                    trigger OnPostDataItem()
                    begin
                        MarkedOnly(true);
                    end;

                    trigger OnPreDataItem()
                    begin
                        TmpWhseActLine.SetRange("Activity Type", "Warehouse Activity Header".Type);
                        TmpWhseActLine.SetRange("No.", "Warehouse Activity Header"."No.");
                        TmpWhseActLine.DeleteAll;
                        if BreakbulkFilter then
                            TmpWhseActLine.SetRange("Original Breakbulk", false);
                        Clear(TmpWhseActLine);
                    end;
                }
                dataitem(WhseActLine; "Warehouse Activity Line")
                {
                    DataItemLink = "Activity Type" = FIELD(Type), "No." = FIELD("No.");
                    DataItemLinkReference = "Warehouse Activity Header";
                    DataItemTableView = SORTING("Activity Type", "No.", "Sorting Sequence No.");
                    column(WhseActLine__Source_No__; "Source No.")
                    {
                    }
                    column(WhseActLine__Shelf_No__; "Shelf No.")
                    {
                    }
                    column(WhseActLine__Item_No__; "Item No.")
                    {
                    }
                    column(WhseActLine_Description; Description)
                    {
                    }
                    column(WhseActLine__Unit_of_Measure_Code_; "Unit of Measure Code")
                    {
                    }
                    column(WhseActLine__Qty__to_Handle_; "Qty. to Handle")
                    {
                    }
                    column(WhseActLine__Destination_No__; "Destination No.")
                    {
                    }
                    column(WhseActLine__Source_No___Control31; "Source No.")
                    {
                    }
                    column(WhseActLine__Zone_Code_; "Zone Code")
                    {
                    }
                    column(WhseActLine__Item_No___Control42; "Item No.")
                    {
                    }
                    column(WhseActLine_Description_Control43; Description)
                    {
                    }
                    column(WhseActLine__Unit_of_Measure_Code__Control51; "Unit of Measure Code")
                    {
                    }
                    column(WhseActLine__Qty__to_Handle__Control53; "Qty. to Handle")
                    {
                    }
                    column(WhseActLine__Destination_No___Control57; "Destination No.")
                    {
                    }
                    column(WhseActLine__Bin_Code_; "Bin Code")
                    {
                    }
                    column(LineaImp; Linea)
                    {
                    }
                    column(WhseActLine__Source_No___Control73; "Source No.")
                    {
                    }
                    column(WhseActLine__Item_No___Control77; "Item No.")
                    {
                    }
                    column(WhseActLine_Description_Control78; Description)
                    {
                    }
                    column(WhseActLine__Destination_No___Control82; "Destination No.")
                    {
                    }
                    column(WhseActLine__Shelf_No___Control83; "Shelf No.")
                    {
                    }
                    column(WhseActLine__Qty__to_Handle__Control85; "Qty. to Handle")
                    {
                    }
                    column(WhseActLine__Unit_of_Measure_Code__Control86; "Unit of Measure Code")
                    {
                    }
                    column(WhseActLine__Unit_of_Measure_Code__Control89; "Unit of Measure Code")
                    {
                    }
                    column(WhseActLine__Qty__to_Handle__Control90; "Qty. to Handle")
                    {
                    }
                    column(WhseActLine__Bin_Code__Control92; "Bin Code")
                    {
                    }
                    column(WhseActLine_Description_Control95; Description)
                    {
                    }
                    column(WhseActLine__Item_No___Control96; "Item No.")
                    {
                    }
                    column(WhseActLine__Destination_No___Control99; "Destination No.")
                    {
                    }
                    column(WhseActLine__Source_No___Control101; "Source No.")
                    {
                    }
                    column(EmptyStringCaption; EmptyStringCaptionLbl)
                    {
                    }
                    column(EmptyStringCaption_Control72; EmptyStringCaption_Control72Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control87; EmptyStringCaption_Control87Lbl)
                    {
                    }
                    column(EmptyStringCaption_Control88; EmptyStringCaption_Control88Lbl)
                    {
                    }
                    column(WhseActLine_Activity_Type; "Activity Type")
                    {
                    }
                    column(WhseActLine_No_; "No.")
                    {
                    }
                    column(WhseActLine_Line_No_; "Line No.")
                    {
                    }
                    column(WhseActLine_Due_Date; "Due Date")
                    {
                    }
                    column(WhseActLine_Bin_Ranking; "Bin Ranking")
                    {
                    }
                    column(Item_Bar_Code; BarCode)
                    {
                    }
                    dataitem(WhseActLine2; "Warehouse Activity Line")
                    {
                        DataItemLink = "Activity Type" = FIELD("Activity Type"), "No." = FIELD("No."), "Bin Code" = FIELD("Bin Code"), "Item No." = FIELD("Item No."), "Action Type" = FIELD("Action Type"), "Variant Code" = FIELD("Variant Code"), "Unit of Measure Code" = FIELD("Unit of Measure Code"), "Due Date" = FIELD("Due Date");
                        DataItemLinkReference = WhseActLine;
                        DataItemTableView = SORTING("Activity Type", "No.", "Bin Code", "Breakbulk No.", "Action Type");
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if SumUpLines then begin
                            TmpWhseActLine.Get("Activity Type", "No.", "Line No.");
                            "Qty. (Base)" := TmpWhseActLine."Qty. (Base)";
                            "Qty. to Handle" := TmpWhseActLine."Qty. to Handle";
                        end;

                        //AMS
                        if (Location."Bin Mandatory") and (not InvtPick) then
                            Linea += 1;

                        //SANTINAV-351++
                        BarCode := ' ';
                        ItemCrossRef.Reset;
                        //Item No.,Variant Code,Unit of Measure,Cross-Reference Type
                        ItemCrossRef.SetRange("Item No.", WhseActLine."Item No.");
                        ItemCrossRef.SetRange("Variant Code", WhseActLine."Variant Code");
                        ItemCrossRef.SetRange("Unit of Measure", WhseActLine."Unit of Measure Code");
                        ItemCrossRef.SetRange("Reference Type", ItemCrossRef."Reference Type"::"Bar Code");
                        if ItemCrossRef.FindFirst then
                            BarCode := ItemCrossRef."Reference No.";
                        //SANTINAV-351-
                    end;

                    trigger OnPreDataItem()
                    begin
                        WhseActLine.Copy("Warehouse Activity Line");
                        Counter := WhseActLine.Count;
                        if Counter = 0 then
                            CurrReport.Break;

                        if BreakbulkFilter then
                            SetRange("Original Breakbulk", false);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                GetLocation("Location Code");
                InvtPick := Type = Type::"Invt. Pick";

                DirAlmacen := Location.Address;
                dirAlmacen2 := Location."Name 2";

                WComLin.Reset;
                WComLin.SetRange("Table Name", WComLin."Table Name"::"Whse. Activity Header");
                WComLin.SetRange(Type, WComLin.Type::Pick);
                WComLin.SetRange("No.", "No.");
                if WComLin.FindFirst then
                    Comentario := WComLin.Comment
                else
                    Comentario := '';

                UsuarioAsig := "Warehouse Activity Header"."Assigned User ID";
                /*MOI - 03/02/2015 (#11350):Inicio
                IF "Assigned User ID" <> '' THEN
                  IF User.GET("Assigned User ID") THEN
                    NombreUsAsig  := User."User Name"
                  ELSE
                    NombreUsAsig := '';
                MOI - 03/02/2015 (#1135)*/

                //MOI - 03/02/2015 (#11350):Inicio
                if "Warehouse Activity Header"."Assigned User ID" <> '' then begin
                    Clear(NombreUsAsig);
                    User.SetCurrentKey("User Name");
                    User.SetRange("User Name", "Warehouse Activity Header"."Assigned User ID");
                    if User.FindFirst then begin
                        NombreUsAsig := User."Full Name";
                    end;
                end;
                //MOI - 03/02/2015 (#11350):Fin

                //+001
                Clear(wDatosEnvio);
                //-001

                if not CurrReport.Preview then
                    WhseCountPrinted.Run("Warehouse Activity Header");

                WAL.Reset;
                WAL.SetRange("Activity Type", Type);
                WAL.SetRange("No.", "No.");
                if WAL.FindFirst then begin
                    NoEnvio := WAL."Whse. Document No.";
                    NoPedido := WAL."Source No.";
                    SH.Reset;
                    SH.SetRange(SH."Document Type", SH."Document Type"::Order);
                    SH.SetRange(SH."No.", WAL."Source No.");
                    if SH.FindFirst then begin
                        FechaLanzado := SH."Fecha Lanzado";
                        HoraLanzado := SH."Hora Lanzado";
                        FechaEnvio := SH."Shipment Date";
                        NombreCliente := SH."Bill-to Name";
                        CodCliente := SH."Bill-to Customer No.";
                        TipoVta := SH."Tipo de Venta";
                        CodVendedor := SH."Salesperson Code";
                        if Vendedor.Get(SH."Salesperson Code") then
                            NombreVendedor := Vendedor.Name
                        else
                            NombreVendedor := '';
                        DirCliente := SH."Bill-to Address" + ' ' + SH."Bill-to Address 2";
                        //+001
                        DatosEnvio(SH);
                        //-001
                    end
                    else begin
                        if TH.Get(WAL."Source No.") then begin
                            FechaLanzado := TH."Fecha Lanzado";
                            HoraLanzado := TH."Hora Lanzado";
                            FechaEnvio := TH."Shipment Date";
                            NombreCliente := TH."Transfer-to Name";
                            CodCliente := TH."Transfer-to Code";
                            // TipoVta := TH."No. Envio";
                        end;
                    end;
                end;

            end;
        }
        dataitem("Sales Comment Line"; "Sales Comment Line")
        {
            //DataItemTableView = SORTING("Document Type", "No.", "Document Line No.", "Line No.") ORDER(Ascending) WHERE("Print On Pick Ticket" = FILTER(true));
            column(Sales_Comment_Line_Comment; Comment)
            {
            }
            column(ComentariosCaption; ComentariosCaptionLbl)
            {
            }
            column(Sales_Comment_Line_Document_Type; "Document Type")
            {
            }
            column(Sales_Comment_Line_No_; "No.")
            {
            }
            column(Sales_Comment_Line_Document_Line_No_; "Document Line No.")
            {
            }
            column(Sales_Comment_Line_Line_No_; "Line No.")
            {
            }

            trigger OnPreDataItem()
            begin
                SetRange("Document Type", "Sales Comment Line"."Document Type"::Order);
                SetRange("No.", NoPedido);
            end;
        }
        dataitem("Inventory Comment Line"; "Inventory Comment Line")
        {
            column(Inventory_Comment_Line_Comment; Comment)
            {
            }
            column(ComentariosCaption_Control1000000016; ComentariosCaption_Control1000000016Lbl)
            {
            }
            column(Inventory_Comment_Line_Document_Type; "Document Type")
            {
            }
            column(Inventory_Comment_Line_No_; "No.")
            {
            }
            column(Inventory_Comment_Line_Line_No_; "Line No.")
            {
            }

            trigger OnPreDataItem()
            begin
                SetRange("Document Type", "Document Type"::"Transfer Order");
                SetRange("No.", NoPedido);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Breakbulk; BreakbulkFilter)
                    {
                        Caption = 'Set Breakbulk Filter';
                        Editable = BreakbulkEditable;
                        ApplicationArea = Basic, Suite;
                    }
                    field(SumUpLines; SumUpLines)
                    {
                        Caption = 'Sum up Lines';
                        Editable = SumUpLinesEditable;
                        ApplicationArea = Basic, Suite;
                    }
                    field(LotSerialNo; ShowLotSN)
                    {
                        Caption = 'Show Serial/Lot Number';

                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            SumUpLinesEditable := true;
            BreakbulkEditable := true;
        end;

        trigger OnOpenPage()
        begin
            if HideOptions then begin
                BreakbulkEditable := false;
                SumUpLinesEditable := false;
            end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        PickFilter := "Warehouse Activity Header".GetFilters;
    end;

    var
        Location: Record Location;
        TmpWhseActLine: Record "Warehouse Activity Line" temporary;
        WhseCountPrinted: Codeunit "Whse.-Printed";
        PickFilter: Text[250];
        BreakbulkFilter: Boolean;
        SumUpLines: Boolean;
        HideOptions: Boolean;
        InvtPick: Boolean;
        ShowLotSN: Boolean;
        Counter: Integer;
        Text25000: Label 'For Kit Item No.:';
        KitItemNoLabel: Text[30];
        BreakbulkEditable: Boolean;
        SumUpLinesEditable: Boolean;
        rSalesCommentLine: Record "Sales Comment Line";
        NoPedido: Code[20];
        I: Integer;
        Cust: Record Customer;
        SH: Record "Sales Header";
        WAL: Record "Warehouse Activity Line";
        NombreCliente: Text[200];
        CodCliente: Code[20];
        TipoVta: Option Venta,Consignacion,Muestras,Donaciones,"Libros obsequiados","Material Promocion",Destrucciones;
        DirAlmacen: Text[100];
        dirAlmacen2: Text[100];
        SIH: Record "Sales Invoice Header";
        TSH: Record "Transfer Shipment Header";
        WComLin: Record "Warehouse Comment Line";
        Comentario: Text[100];
        UsuarioImp: Code[20];
        NoEnvio: Code[20];
        UsuarioAsig: Code[20];
        NombreUsAsig: Text[100];
        User: Record User;
        TH: Record "Transfer Header";
        FechaLanzado: Date;
        HoraLanzado: Time;
        FechaEnvio: Date;
        Linea: Integer;
        CodVendedor: Code[20];
        NombreVendedor: Text[200];
        Vendedor: Record "Salesperson/Purchaser";
        DirCliente: Text[400];
        wDatosEnvio: array[5] of Text[203];
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Picking_ListCaptionLbl: Label 'Picking List';
        Tipo_Venta_CaptionLbl: Label 'Tipo Venta:';
        Cliente_LBLLbl: Label 'Cliente:';
        "Datos_envío_CaptionLbl": Label 'Datos envío:';
        CurrReport_PAGENO_Control4CaptionLbl: Label 'Page';
        Picking_ListCaption_Control5Lbl: Label 'Picking List';
        WhseActLine__Unit_of_Measure_Code_CaptionLbl: Label 'Cód. U. M.';
        Qty__HandledCaptionLbl: Label 'Qty. Handled';
        WhseActLine__Unit_of_Measure_Code__Control51CaptionLbl: Label 'Cód. U. M.';
        Qty__HandledCaption_Control69Lbl: Label 'Qty. Handled';
        Qty__HandledCaption_Control103Lbl: Label 'Qty. Handled';
        WhseActLine__Unit_of_Measure_Code__Control86CaptionLbl: Label 'Cód. U. M.';
        Qty__HandledCaption_Control117Lbl: Label 'Qty. Handled';
        WhseActLine__Unit_of_Measure_Code__Control89CaptionLbl: Label 'Cód. U. M.';
        EmptyStringCaptionLbl: Label '____________';
        EmptyStringCaption_Control72Lbl: Label '____________';
        EmptyStringCaption_Control87Lbl: Label '____________';
        EmptyStringCaption_Control88Lbl: Label '____________';
        ComentariosCaptionLbl: Label 'Comentarios';
        ComentariosCaption_Control1000000016Lbl: Label 'Comentarios';
        BarCode: Code[20];
        ItemCrossRef: Record "Item Reference";
        CodigoBarrasLbl: Label 'Cód. Barras';

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Location.Init
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;


    procedure SetBreakbulkFilter(BreakbulkFilter2: Boolean)
    begin
        BreakbulkFilter := BreakbulkFilter2;
    end;


    procedure SetInventory(SetHideOptions: Boolean)
    begin
        HideOptions := SetHideOptions;
    end;


    procedure DatosEnvio(lrPedido: Record "Sales Header")
    var
        lPos: Integer;
    begin
        //+001
        Clear(wDatosEnvio);
        lPos := 1;

        //... Código y contacto en una línea.
        LineaEnvio(lrPedido."Ship-to Code", lrPedido."Ship-to Contact", lPos);

        //... Nombre + tfno. en una línea
        LineaEnvio(lrPedido."Ship-to Name", lrPedido."Ship-to Phone", lPos);

        //002+
        //ORIGINAL
        /*
        //... Dirección y ciudad en la misma linea.
        LineaEnvio(lrPedido."Ship-to Address",lrPedido."Ship-to City",lPos);
        
        //... Ultima línea: Provincia, area o estado
        LineaEnvio(lrPedido."Ship-to County",'',lPos);
        */
        //MODIFICADO
        if lrPedido."Ship-to Address 2" = '' then begin
            //... Dirección y ciudad en la misma linea.
            LineaEnvio(lrPedido."Ship-to Address", lrPedido."Ship-to City", lPos);

            //... Ultima línea: Provincia, area o estado
            LineaEnvio(lrPedido."Ship-to County", '', lPos);
        end
        else begin
            //... Dirección y ciudad en la misma linea.
            LineaEnvio(lrPedido."Ship-to Address", lrPedido."Ship-to Address 2", lPos);

            //... Ultima línea: Provincia, area o estado
            LineaEnvio(lrPedido."Ship-to City", lrPedido."Ship-to County", lPos);
        end;
        //002-

    end;


    procedure LineaEnvio(p1: Text[100]; p2: Text[100]; var vPos: Integer)
    begin
        //+001
        //... Juntamos los valores p1 y p2 en una línea.
        //... Incrementamos la línea si se han encontrado datos.
        if p1 <> '' then
            wDatosEnvio[vPos] := p1;

        if p2 <> '' then begin
            if wDatosEnvio[vPos] <> '' then
                wDatosEnvio[vPos] := wDatosEnvio[vPos] + ' - ';
            wDatosEnvio[vPos] := wDatosEnvio[vPos] + p2;
        end;

        if wDatosEnvio[vPos] <> '' then
            vPos := vPos + 1;
    end;
}

