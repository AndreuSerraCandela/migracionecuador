xmlport 50001 "Importar Ped Call Center vs2"
{
    // YFC     : Yefrecis Francisco Cruz
    // FES     : Fausto Serrata
    // ------------------------------------------------------------------------
    // No.         Firma   Fecha         Descripcion
    // ------------------------------------------------------------------------
    // 001         YFC     12/05/2020    SANTINAV-1424
    // 002         FES     17-Feb-2021   SANTINAV-2149. Mejoras importación pedidos Call Center
    // 006         FES     23-Nov-2022    Adicionar COMMIT para WebClient
    // 007         LDP     13-02-2022    SANTINAV-4176:Agregar cliente para carga de pedidos TOL
    // 008         LDP     28/05/2024    SANTINAV-6299
    // 009         LDP     03/01/2025    SANTINAV-6728

    Caption = 'Importar Pedidos Call Center';
    DefaultNamespace = 'xmlns:xsi=http://www.w3.org/2001/XMLSchema-instance';
    Encoding = UTF8;
    FormatEvaluate = Legacy;
    InlineSchema = false;
    PreserveWhiteSpace = false;
    UseDefaultNamespace = false;
    UseLax = false;

    schema
    {
        textelement(Pedidos_CallCenter)
        {
            MinOccurs = Once;
            textelement(Cabeceras)
            {
                textelement(Cabecera)
                {
                    textelement(no_documento)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            no_documento := '1';
                        end;
                    }
                    textelement(no_cliente_)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            no_cliente_ := '1';//007+-
                        end;
                    }
                    textelement(fecha_pedido)
                    {
                        MaxOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            fecha_pedido := '1';
                        end;
                    }
                    textelement(nombre_cliente)
                    {
                        MaxOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            nombre_cliente := '2'
                        end;
                    }
                    textelement(tipo_documento)
                    {
                        MaxOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            tipo_documento := '1';
                        end;
                    }
                    textelement(tipo_ruc)
                    {
                        MaxOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            tipo_ruc := '1';
                        end;
                    }
                    textelement(ruc)
                    {
                        MaxOccurs = Once;

                        trigger OnBeforePassVariable()
                        begin
                            ruc := '1';
                        end;

                        trigger OnAfterAssignVariable()
                        begin
                            if tipo_documento = 'RUC' then begin
                                case tipo_ruc of
                                    'RUC Jurídicos y Extranjeros':
                                        Tipo := 1; // RUC Jurídicos y Extranjeros
                                    'RUC Publicos':
                                        Tipo := 2; // RUC Publicos
                                    'RUC Persona Natura':
                                        Tipo := 3; // RUC Persona Natural
                                    'Cedula':
                                        Tipo := 4; //
                                    else
                                        Error('El tipo de RUC no es válido.');
                                end;
                                MensajeRUC := ValidaRUC.ValidaDigitosRUC(ruc, Tipo, false);
                                Error(MensajeRUC);
                            end
                            else
                                if tipo_documento = 'Cedula' then begin
                                    if StrLen(ruc) <> 10 then
                                        //    MensajeRUC := ValidaRUC.ValidaCedula(ruc);
                                        Error(MensajeRUC);
                                end;
                        end;
                    }
                    textelement(cod_colegio)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                    }
                    textelement(venta_direccion)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(venta_municipio)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(venta_estado)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(telefono)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(email)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(doc_externo)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                    }
                    textelement(serie_NCFfacturas)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                    }
                    textelement(serie_NCFremision)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                    }
                    textelement(almacen)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(envio_estado)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(envio_municipio)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(envio_nombre)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(envio_telefono)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(envio_direccion)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(cod_transportista)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                    }
                    textelement(fecha_inicioTransporte)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                    }
                    textelement(fecha_finTransporte)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;

                        trigger OnAfterAssignVariable()
                        begin

                            SH.Init;
                            SH.Validate("Document Type", SH."Document Type"::Order);
                            //SH.VALIDATE("No.",no_documento);
                            SH."No." := no_documento;
                            SH."Sell-to Customer No." := no_cliente_;//007+-
                            SH.Validate("Venta Call Center", true);
                            SH.Insert(true);

                            Clear(ConvertFecha);
                            Evaluate(ConvertFecha, fecha_pedido);
                            SH.Validate("Order Date", ConvertFecha);
                            SH.Validate("Sell-to Customer Name", nombre_cliente);
                            SH.Validate("Bill-to Customer No.", no_cliente_); //LDP-007+-
                            SH.Validate("Order Date", ConvertFecha);//LDP-007+-

                            //008+
                            if Customer.Get(no_cliente_) then;
                            if SH."Collector Code" = '' then
                                SH.Validate("Collector Code", Customer."Collector Code");
                            if envio_nombre <> '' then
                                SH.Validate("Bill-to Name", envio_nombre);
                            //008-

                            case tipo_documento of
                                //002+
                                /*
                                  'RUC': SH.VALIDATE("Tipo Documento",SH."Tipo Documento"::RUC);
                                  'Cedula': SH.VALIDATE("Tipo Documento",SH."Tipo Documento"::Cedula);
                                  'Pasaporte': SH.VALIDATE("Tipo Documento",SH."Tipo Documento"::Pasaporte);
                                */
                                'RUC':
                                    SH."Tipo Documento SrI" := SH."Tipo Documento SrI"::RUC;
                                'Cedula':
                                    SH."Tipo Documento SrI" := SH."Tipo Documento SrI"::Cedula;
                                'Pasaporte':
                                    SH."Tipo Documento SrI" := SH."Tipo Documento SrI"::Pasaporte;
                            //002-
                            end;

                            case tipo_ruc of
                                //002+
                                /*
                                  'R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA': SH.VALIDATE("Tipo Ruc/Cedula",SH."Tipo Ruc/Cedula"::"R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA");
                                  'R.U.C. PUBLICOS': SH.VALIDATE("Tipo Ruc/Cedula",SH."Tipo Ruc/Cedula"::"R.U.C. PUBLICOS");
                                  'RUC PERSONA NATURAL': SH.VALIDATE("Tipo Ruc/Cedula",SH."Tipo Ruc/Cedula"::"RUC PERSONA NATURAL");
                                  'CEDULA': SH.VALIDATE("Tipo Ruc/Cedula", SH."Tipo Ruc/Cedula"::CEDULA);
                                */
                                'R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA':
                                    SH."Tipo Ruc/Cedula" := SH."Tipo Ruc/Cedula"::"R.U.C. JURIDICOS Y EXTRANJEROS SIN CEDULA";
                                'R.U.C. PUBLICOS':
                                    SH."Tipo Ruc/Cedula" := SH."Tipo Ruc/Cedula"::"R.U.C. PUBLICOS";
                                'RUC PERSONA NATURAL':
                                    SH."Tipo Ruc/Cedula" := SH."Tipo Ruc/Cedula"::"RUC PERSONA NATURAL";
                                'CEDULA':
                                    SH."Tipo Ruc/Cedula" := SH."Tipo Ruc/Cedula"::CEDULA;
                            //002-
                            end;


                            SH.Validate("VAT Registration No.", ruc);
                            if cod_colegio <> '' then
                                SH."Cod. Colegio" := cod_colegio;
                            SH.Validate("Sell-to Address", venta_direccion);
                            SH.Validate("Sell-to Address 2", '');
                            SH.Validate("Sell-to City", venta_municipio);
                            SH.Validate("Sell-to County", venta_estado);
                            SH.Validate("Sell-to Contact", '');

                            SH.Validate("Sell-to Phone", telefono);
                            SH.Validate("E-Mail", email);
                            SH."External Document No." := doc_externo;
                            if serie_NCFfacturas <> '' then
                                SH.Validate("No. Serie NCF Facturas", serie_NCFfacturas);
                            if serie_NCFremision <> '' then
                                SH.Validate("No. Serie NCF Remision", serie_NCFremision);
                            SH.Validate("Location Code", almacen);

                            //envio
                            SH."Ship-to County" := envio_estado;
                            SH."Ship-to City" := envio_municipio;
                            SH."Ship-to Name" := envio_nombre;
                            SH."Ship-to Phone" := envio_telefono;
                            SH."Ship-to Address" := envio_direccion;

                            if cod_transportista <> '' then
                                SH.Validate("Shipping Agent Code", cod_transportista);

                            Clear(ConvertFecha);
                            if fecha_inicioTransporte <> '' then begin
                                Evaluate(ConvertFecha, fecha_inicioTransporte);
                                SH.Validate("Fecha inicio trans.", ConvertFecha);
                            end;

                            Clear(ConvertFecha);
                            if fecha_finTransporte <> '' then begin
                                Evaluate(ConvertFecha, fecha_finTransporte);
                                SH.Validate("Fecha fin trans.", ConvertFecha);
                            end;

                            SH.Modify;
                            Commit;  //006+-

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
                            no_pedido := '1';
                        end;
                    }
                    textelement(no_cliente)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            no_cliente := '1';
                        end;
                    }
                    textelement(tipo_producto)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(producto)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(cantidad)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(precio_unitario_sinIVA)
                    {
                        MaxOccurs = Once;
                    }
                    textelement(importe_dto)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                    }
                    textelement(grupo_registroIVA_product)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;

                        trigger OnAfterAssignVariable()
                        begin

                            SL.Init;
                            SL.Validate("Document Type", SL."Document Type"::Order);
                            SL.Validate("Document No.", no_pedido);

                            if NoDoc_anterior = '' then
                                NoDoc_anterior := no_pedido;

                            if Nolinea = 0 then
                                Nolinea := 10000;

                            if NoDoc_anterior = no_pedido then
                                Nolinea += 10000
                            else begin
                                Nolinea := 10000;
                                NoDoc_anterior := no_pedido;
                            end;

                            SL.Validate("Line No.", Nolinea);
                            SL.Validate("Sell-to Customer No.", no_cliente);
                            SL.Validate("Bill-to Customer No.", no_cliente); //LDP-007

                            case tipo_producto of
                                'Cuenta':
                                    SL.Validate(Type, SL.Type::"G/L Account");
                                'Producto':
                                    SL.Validate(Type, SL.Type::Item);
                            end;

                            SL.SetHideValidationDialog(true);  //002+-
                            SL.Validate("No.", producto);

                            Clear(ConvertDecimal);
                            Evaluate(ConvertDecimal, cantidad);
                            SL.Validate(Quantity, ConvertDecimal);
                            //MESSAGE(cantidad,SL.Quantity);
                            if precio_unitario_sinIVA <> '' then begin
                                Clear(ConvertDecimal);
                                NuevoValor := precio_unitario_sinIVA.Replace('.', ',');
                                Evaluate(ConvertDecimal, NuevoValor);
                                SL.Validate("Unit Price", ConvertDecimal);
                            end;

                            //LDP-007+-
                            if (SL.Quantity = 0) then begin
                                Clear(ConvertDecimal);
                                Evaluate(ConvertDecimal, cantidad);
                                SL.Validate(SL.Quantity, ConvertDecimal);
                            end;
                            //007++

                            if (importe_dto <> '') and (importe_dto <> '0') then begin
                                Clear(ConvertDecimal);
                                StrParam := ConvertStr(importe_dto, '.', ',');//LDP-007+-
                                Evaluate(ConvertDecimal, StrParam);//LDP-007+-
                                                                   //EVALUATE(ConvertDecimal,importe_dto);//LDP-007+-
                                SL.Validate("Line Discount Amount", ConvertDecimal);
                            end;

                            if grupo_registroIVA_product <> '' then
                                SL.Validate("VAT Prod. Posting Group", grupo_registroIVA_product);

                            if SL.Quantity = 0 then begin
                                Clear(ConvertDecimal);
                                Evaluate(ConvertDecimal, cantidad);
                                SL.Validate(Quantity, ConvertDecimal);
                            end;
                            SL.Insert;
                            Commit;  //006+-
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

    var
        SH: Record "Sales Header";
        SL: Record "Sales Line";
        ConvertFecha: Date;
        ConvertDecimal: Decimal;
        Nolinea: Integer;
        NoDoc_anterior: Code[20];
        NuevoValor: Text;
        StrParam: Text[1024];
        Customer: Record Customer;
        ErrorRUC: Label 'RUC is not correct';
        ErrorCedula: Label 'Ceula is not correct';
        MensajeRUC: Text[250];
        ValidaRUC: Codeunit "Funciones Ecuador";
        Tipo: Integer;
}

