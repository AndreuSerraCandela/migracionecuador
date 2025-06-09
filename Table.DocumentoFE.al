table 55008 "Documento FE"
{
    // #35982  20/11/2015 JML : Modificaciones para esquema off-line. Se amplian el nº de autorización a 49.
    // #35029  19.10.2017 RRT : Se crea la clave <Estado envio, Estado autorizacion,Fecha emision>, poder usar en el proceso de envio y autorización SRI
    // #203574 27.03.2019 RRT : Creación del key CLAVE
    // SANTINAV-499, 29.07.19, RRT: Ampliar el tamaño del campo "Id. comprador" a 17 caracters (eran 13)


    fields
    {
        field(10; "No. documento"; Code[20])
        {
            Caption = 'No. documento';
        }
        field(20; "Fecha emision"; Date)
        {
            Caption = 'Fecha emision';
        }
        field(30; "Dir. establecimiento"; Text[100])
        {
            Caption = 'Dir. establecimiento';
        }
        field(40; "Contribuyente especial"; Text[5])
        {
            Caption = 'Contribuyente especial';
        }
        field(50; "Obligado contabilidad"; Text[2])
        {
            Caption = 'Obligado contabilidad';
        }
        field(60; "Tipo id."; Text[2])
        {
            Caption = 'Tipo id.';
        }
        field(70; "Guia remision"; Text[20])
        {
            Caption = 'Guia remisión';
        }
        field(80; "Razon social"; Text[100])
        {
            Caption = 'Razon social';
        }
        field(90; "Id. comprador"; Text[17])
        {
            Caption = 'Id. comprador';
        }
        field(95; "id. sujeto retenido"; Text[20])
        {
        }
        field(100; "Total sin impuestos"; Decimal)
        {
            Caption = 'Total sin impuestos';
        }
        field(110; "Total descuento"; Decimal)
        {
            Caption = 'Total descuento';
        }
        field(120; Propina; Decimal)
        {
            Caption = 'Propina';
        }
        field(130; "Importe total"; Decimal)
        {
            Caption = 'Importe total';
        }
        field(140; Moneda; Text[30])
        {
            Caption = 'Moneda';
        }
        field(150; Establecimiento; Code[3])
        {
            Caption = 'Establecimiento';
        }
        field(160; "Punto de emision"; Code[3])
        {
            Caption = 'Punto de emisión';
        }
        field(170; Secuencial; Code[9])
        {
            Caption = 'Secuencial';
        }
        field(180; "Dir. partida"; Text[100])
        {
            Caption = 'Dir. partida';
        }
        field(210; "RUC transportista"; Code[20])
        {
            Caption = 'RUC transportista';
        }
        field(215; "Nombre transportista"; Text[100])
        {
        }
        field(220; Rise; Text[40])
        {
            Caption = 'Rise';
        }
        field(225; "Tipo id. trans."; Text[2])
        {
            Caption = 'Tipo id.';
        }
        field(230; "Fecha ini. transporte"; Date)
        {
            Caption = 'Fecha ini. transporte';
        }
        field(240; "Fecha fin transporte"; Date)
        {
            Caption = 'Fecha fin transporte';
        }
        field(250; Placa; Code[20])
        {
            Caption = 'Placa';
        }
        field(260; "Id. destinatario"; Text[20])
        {
            Caption = 'Id. destinatario';
        }
        field(270; "Razon social destinatario"; Text[100])
        {
            Caption = 'Razón social destinatario';
        }
        field(280; "Doc. aduanero unico"; Text[20])
        {
            Caption = 'Doc. aduanero unico';
        }
        field(290; "Cod. etablecimiento destino"; Text[3])
        {
            Caption = 'Cód. etablecimiento destino';
        }
        field(300; Ruta; Text[100])
        {
            Caption = 'Ruta';
        }
        field(310; "Cod. doc. sustento"; Text[2])
        {
            Caption = 'Cód. doc. sustento';
        }
        field(320; "Num. doc. sustento"; Text[20])
        {
            Caption = 'Núm. doc. sustento';
        }
        field(330; "Num. aut. doc. sustento"; Text[49])
        {
            Caption = 'Núm. aut. doc. sustento';
        }
        field(340; "Fecha emisión doc. sustento"; Date)
        {
            Caption = 'Fecha emisión doc. sustento';
        }
        field(341; "Direccion destinatario"; Text[100])
        {
            Caption = 'Direccion destinatario';
        }
        field(350; Motivo; Text[100])
        {
            Caption = 'Motivo';
        }
        field(360; "Cod. doc. modificado"; Code[2])
        {
            Caption = 'Cod. doc. modificado';
        }
        field(370; "Num. doc. modificado"; Code[20])
        {
            Caption = 'Num. doc. modificado';
        }
        field(380; "Valor modificacion"; Decimal)
        {
            Caption = 'Valor modificacion';
        }
        field(400; Clave; Code[49])
        {
            Caption = 'Clave';
        }
        field(410; RUC; Text[20])
        {
            Caption = 'RUC';
        }
        field(420; "Tipo comprobante"; Code[2])
        {
            Caption = 'Tipo comprobante';
        }
        field(430; "Tipo documento"; Option)
        {
            Caption = 'Tipo documento';
            OptionCaption = 'Factura,Retención,Remisión,Nota Credito,Nota Debito,Liquidacion';
            OptionMembers = Factura,Retencion,Remision,NotaCredito,NotaDebito,Liquidacion;
        }
        field(440; "Subtipo documento"; Option)
        {
            OptionCaption = ',Venta,Transferencia';
            OptionMembers = " ",Venta,Transferencia;
        }
        field(500; "Estado envio"; Option)
        {
            Caption = 'Estado envío';
            OptionCaption = 'Pendiente,Enviado,Rechazado';
            OptionMembers = Pendiente,Enviado,Rechazado;
        }
        field(501; "Estado autorizacion"; Option)
        {
            Caption = 'Estado autorización';
            OptionCaption = 'Pendiente,Autorizado,No autorizado';
            OptionMembers = Pendiente,Autorizado,"No autorizado";
        }
        field(502; "No. autorizacion"; Text[60])
        {
            Caption = 'No. autorización';
        }
        field(503; "Fecha hora autorizacion"; Text[30])
        {
            Caption = 'Fecha hora autorización';
        }
        field(504; Ambiente; Option)
        {
            Caption = 'Ambiente';
            OptionCaption = 'Pruebas,Producción';
            OptionMembers = Pruebas,Produccion;
        }
        field(505; "Fecha hora ult. envio"; DateTime)
        {
            Caption = 'Fecha hora último envío';
        }
        field(506; "Tipo emision"; Option)
        {
            Caption = 'Tipo emisión';
            OptionCaption = 'Normal,Contingencia';
            OptionMembers = Normal,Contingencia;
        }
        field(510; "Periodo fiscal"; Text[30])
        {
        }
        field(520; "Adicional - Direccion"; Text[100])
        {
        }
        field(530; "Adicional - Telefono"; Text[30])
        {
        }
        field(540; "Adicional - Email"; Text[80])
        {
        }
        field(550; "Adicional - Pedido"; Code[20])
        {
        }
        field(551; "Documento Origen"; Code[20])
        {
        }
        field(552; "Tipo Doc"; Code[10])
        {
        }
        field(560; "Forma de Pago"; Code[2])
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-6697';
        }
        field(561; "Pago total"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-6697';
        }
        field(562; "Plazo Pago"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-6697';
        }
        field(563; "Unidad Tiempo Pago"; Text[10])
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-6697';
        }
    }

    keys
    {
        key(Key1; "No. documento")
        {
            Clustered = true;
        }
        key(Key2; "Cod. doc. sustento", "Num. doc. sustento")
        {
        }
        key(Key3; "Estado envio", "Estado autorizacion", "Fecha emision")
        {
        }
        key(Key4; Clave)
        {
        }
        key(Key5; "Fecha emision")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        recTmpTotImp.Reset;
        recTmpTotImp.SetRange("No. documento", "No. documento");
        recTmpTotImp.DeleteAll;

        recTmpDet.Reset;
        recTmpDet.SetRange("No. documento", "No. documento");
        recTmpDet.DeleteAll;

        recTmpImp.Reset;
        recTmpImp.SetRange("No. documento", "No. documento");
        recTmpImp.DeleteAll;

        recTmpRet.Reset;
        recTmpRet.SetRange("No. documento", "No. documento");
        recTmpRet.DeleteAll;
    end;

    var
        recTmpTotImp: Record "Total Impuestos FE";
        recTmpDet: Record "Detalle FE";
        recTmpImp: Record "Impuestos FE";
        recTmpRet: Record "Retenciones FE";
}

