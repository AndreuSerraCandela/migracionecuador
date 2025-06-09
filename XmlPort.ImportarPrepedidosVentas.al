xmlport 50003 "Importar Prepedidos Ventas"
{
    // YFC     : Yefrecis Francisco Cruz
    // ------------------------------------------------------------------------
    // No.         Firma   Fecha         Descripcion
    // ------------------------------------------------------------------------
    // 001         YFC     31/01/2024    SANTINAV-5207
    // 002         LDP     28/05/2024    SANTINAV-6299
    // 003         LDP     03/01/2025    SANTINAV-6728

    Caption = 'Import Preorders Massively';
    DefaultNamespace = 'xmlns:xsi=http://www.w3.org/2001/XMLSchema-instance';
    Encoding = UTF8;
    FormatEvaluate = Legacy;
    InlineSchema = false;
    PreserveWhiteSpace = false;
    UseDefaultNamespace = false;
    UseLax = false;

    schema
    {
        textelement(PrePedidos_Ventas)
        {
            MinOccurs = Once;
            textelement(Cabeceras)
            {
                textelement(Cabecera)
                {
                    textelement(no_documento)
                    {
                        MaxOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            no_documento := 'no_documento';
                        end;
                    }
                    textelement(no_cliente)
                    {
                        MaxOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            no_cliente := 'no_cliente';
                        end;
                    }
                    textelement(almacen)
                    {
                        MaxOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            almacen := 'almacen';
                        end;
                    }
                    textelement(doc_externo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            doc_externo := 'doc_externo';
                        end;
                    }
                    textelement(cod_colegio)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            cod_colegio := 'cod_colegio';
                        end;
                    }
                    textelement(cod_vendedor)
                    {
                        MaxOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            cod_vendedor := 'cod_vendedor';
                        end;
                    }
                    textelement(cod_direccion_envio)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;

                        trigger OnBeforePassVariable()
                        begin
                            cod_direccion_envio := 'cod_direccion_envio';
                        end;
                    }
                    textelement(envio_nombre)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;

                        trigger OnBeforePassVariable()
                        begin
                            //envio_direccion := 'envio_nombre';
                            envio_direccion := 'envio_nombre';//003+
                        end;
                    }
                    textelement(envio_direccion)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;

                        trigger OnBeforePassVariable()
                        begin
                            //envio_colonia2 := 'envio_direccion';
                            envio_direccion := 'envio_direccion';//003+-
                        end;
                    }
                    textelement(envio_colonia2)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;

                        trigger OnBeforePassVariable()
                        begin
                            //envio_cp := 'envio_colonia2';
                            envio_colonia2 := 'envio_colonia2';//003+-
                        end;
                    }
                    textelement(envio_cp)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;

                        trigger OnBeforePassVariable()
                        begin
                            //no_periodo := 'envio_cp';
                            envio_cp := 'envio_cp';//003+-
                        end;
                    }
                    textelement(no_periodo)
                    {
                        MaxOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            //cod_direccion_envio := 'no_periodo';
                            no_periodo := 'no_periodo';//003+-
                        end;

                        trigger OnAfterAssignVariable()
                        begin
                            // ++ 001-YFC
                            SH.Init;
                            SH.Validate("Document Type", SH."Document Type"::Order);
                            //SH.VALIDATE("No.",no_documento);
                            SH."No." := no_documento;
                            //SH."Sell-to Customer No." := no_cliente;

                            SH.Validate("Pre pedido", true);
                            SH.Validate("Sell-to Customer No.", no_cliente);


                            SH.Insert(true);

                            //CLEAR(ConvertFecha);
                            //EVALUATE(ConvertFecha,fecha_pedido);

                            SH.Validate("Order Date", Today);
                            SH.Validate("Posting Date", Today);
                            SH.Validate("Shipment Date", Today);
                            SH.Validate("Bill-to Customer No.", no_cliente);
                            //002+
                            if Customer.Get(no_cliente) then;
                            if SH."Collector Code" = '' then
                                SH.Validate("Collector Code", Customer."Collector Code");
                            //003+
                            //002-
                            if envio_nombre <> '' then
                                SH.Validate("Bill-to Name", envio_nombre);
                            //002-
                            //003-
                            //SH."Cod. Colegio" := cod_colegio ;
                            //SH."External Document No." := doc_externo ;

                            SH.Validate("Cod. Colegio", cod_colegio);
                            SH.Validate("External Document No.", doc_externo);
                            SH.Validate("Location Code", almacen);
                            SH.Validate("Salesperson Code", cod_vendedor);
                            SH.Validate("Campaign No.", no_periodo);

                            if envio_nombre = '' then
                                SH.Validate("Ship-to Code", cod_direccion_envio)
                            else begin
                                // ++ envio
                                if envio_nombre <> '' then
                                    SH.Validate("Ship-to Name", envio_nombre);

                                if envio_direccion <> '' then
                                    SH.Validate("Ship-to Address", envio_direccion);

                                if envio_colonia2 <> '' then
                                    SH.Validate("Ship-to Address 2", envio_colonia2);

                                if envio_cp <> '' then
                                    SH.Validate("Ship-to Post Code", envio_cp);


                                //SH."Ship-to Phone"  :=  envio_telefono;
                                //SH."Ship-to City" := envio_municipio ;
                                //SH."Ship-to County" := envio_estado  ;
                                // -- envio
                            end;

                            //SH.VALIDATE("Ship-to Post Code",no_periodo);//003+- Se comenta por comentario en jira.

                            SH.Modify;
                            Commit;
                            // -- 001-YFC
                        end;
                    }
                }
            }
            textelement(Lineas)
            {
                textelement(Linea)
                {
                    textelement(no_pedido)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            no_pedido := 'no_pedido';
                        end;
                    }
                    textelement(tipo_producto)
                    {
                        MaxOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            tipo_producto := 'tipo_producto';
                        end;
                    }
                    textelement(producto)
                    {
                        MaxOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            producto := 'producto';
                        end;
                    }
                    textelement(cantidad)
                    {
                        MaxOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            cantidad := 'cantidad';
                        end;
                    }
                    textelement(importe_dto)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;

                        trigger OnBeforePassVariable()
                        begin
                            precio_unitario_sinIVA := 'importe_dto';
                        end;
                    }
                    textelement(precio_unitario_sinIVA)
                    {
                        MaxOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            importe_dto := 'precio_unitario_sinIVA';
                        end;
                    }
                    textelement(grupo_registroIVA_product)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;

                        trigger OnBeforePassVariable()
                        begin
                            grupo_registroIVA_product := 'grupo_registroIVA_product';
                        end;

                        trigger OnAfterAssignVariable()
                        begin

                            // ++ 001-YFC
                            SL.Init;
                            SL.Validate("Document Type", SL."Document Type"::Order);
                            SL.Validate("Document No.", no_pedido);

                            if NoDoc_anterior = '' then begin
                                NoDoc_anterior := no_pedido;

                                if Nolinea = 0 then
                                    Nolinea := 10000;
                            end
                            else begin
                                if NoDoc_anterior = no_pedido then begin
                                    Nolinea += 10000;
                                end
                                else begin
                                    _pedidos.Get(SL."Document Type", NoDoc_anterior);
                                    //_pedidos.VALIDATE("% de aprobacion",100);
                                    // _pedidos.MODIFY();

                                    Nolinea := 10000;
                                    NoDoc_anterior := no_pedido;

                                end;
                            end;

                            SL.Validate("Line No.", Nolinea);
                            //SL.VALIDATE("Sell-to Customer No." ,no_cliente);
                            //SL.VALIDATE("Bill-to Customer No.",no_cliente);

                            case tipo_producto of
                                'Cuenta':
                                    SL.Validate(Type, SL.Type::"G/L Account");
                                'Producto':
                                    SL.Validate(Type, SL.Type::Item);
                                'Recurso':
                                    SL.Validate(Type, SL.Type::Resource);
                                'Activo Fijo':
                                    SL.Validate(Type, SL.Type::"Fixed Asset");
                                'Cargo (prod.)':
                                    SL.Validate(Type, SL.Type::"Charge (Item)");
                            end;

                            SL.SetHideValidationDialog(true);
                            SL.Validate("No.", producto);

                            Clear(ConvertDecimal);
                            Evaluate(ConvertDecimal, cantidad);
                            SL.Validate("Cantidad Solicitada", ConvertDecimal);

                            if precio_unitario_sinIVA <> '' then begin
                                Clear(ConvertDecimal);
                                precio_unitario_sinIVA := precio_unitario_sinIVA.Replace('.', ',');
                                Evaluate(ConvertDecimal, NuevoValor);
                                SL.Validate("Unit Price", ConvertDecimal);
                            end;

                            if (SL."Cantidad Solicitada" = 0) then begin
                                Clear(ConvertDecimal);
                                Evaluate(ConvertDecimal, cantidad);
                                SL.Validate(SL."Cantidad Solicitada", ConvertDecimal);
                            end;

                            if (importe_dto <> '') and (importe_dto <> '0') then begin
                                Clear(ConvertDecimal);
                                StrParam := ConvertStr(importe_dto, '.', ',');
                                Evaluate(ConvertDecimal, StrParam);
                                SL.Validate("Line Discount Amount", ConvertDecimal);
                            end;

                            if grupo_registroIVA_product <> '' then
                                SL.Validate("VAT Prod. Posting Group", grupo_registroIVA_product);

                            if SL."Cantidad Solicitada" = 0 then begin
                                Clear(ConvertDecimal);
                                Evaluate(ConvertDecimal, cantidad);
                                SL.Validate("Cantidad Solicitada", ConvertDecimal);
                            end;

                            SL.Insert;
                            Commit;
                            // -- 001-YFC
                        end;
                    }
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin

        if _pedidos.Get(_pedidos."Document Type"::Order, NoDoc_anterior) then begin
            //_pedidos.VALIDATE("% de aprobacion",100);
            //_pedidos.MODIFY();
        end;

        Message(Tex01);
    end;

    var
        SH: Record "Sales Header";
        SL: Record "Sales Line";
        ConvertFecha: Date;
        ConvertDecimal: Decimal;
        Nolinea: Integer;
        NoDoc_anterior: Code[20];
        NuevoValor: Text;
        StrParam: Text[1024];
        _pedidos: Record "Sales Header";
        Tex01: Label 'Proceso Finalizado';
        Customer: Record Customer;
}

