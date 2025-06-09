#pragma implicitwith disable
page 76218 "Ficha de Atenciones"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Cab. Atenciones";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = wMod;
                field(Codigo; rec.Codigo)
                {
                }
                field("No. Solicitud"; rec."No. Solicitud")
                {
                }
                field("Grupo de Negocio"; rec."Grupo de Negocio")
                {
                }
                field("Tipo Evento"; rec."Tipo Evento")
                {
                }
                field("Fecha registro"; rec."Fecha registro")
                {
                }
                field("Id. Usuario"; rec."Id. Usuario")
                {
                }
                field(Estado; rec.Estado)
                {
                }
                field("Tipo documento"; rec."Tipo documento")
                {
                }
                field(Documento; rec.Documento)
                {
                }
                field("Fecha Recepción Documento"; rec."Fecha Recepción Documento")
                {
                }
                field(Delegacion; rec.Delegacion)
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field(Distritos; rec.Distritos)
                {
                }
                field(Address; rec.Address)
                {
                }
                field(City; rec.City)
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field(Turno; rec.Turno)
                {
                }
                field(Objetivo; rec.Objetivo)
                {
                }
                field("Descripcion Objetivo"; rec."Descripcion Objetivo")
                {
                }
            }
            group("Entrega Atenciones")
            {
                Editable = wMod;
                field("Area Responsable"; rec."Area Responsable")
                {
                }
                field("Cod. Responsable"; rec."Cod. Responsable")
                {
                }
                field("Nombre responsable"; rec."Nombre responsable")
                {
                }
                field("Fecha de entrega"; rec."Fecha de entrega")
                {
                }
                field("Comentarios Entrega"; rec."Comentarios Entrega")
                {
                }
                field("Comentarios Cancelación"; rec."Comentarios Cancelación")
                {
                }
            }
            part(Control1000000023; "Detalle Atenciones")
            {
                Editable = wMod;
                SubPageLink = "Código Cab. Atención" = FIELD(Codigo);
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Rechazar)
            {
                Caption = 'Rechazar';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = wCambEstado;

                trigger OnAction()
                begin
                    Rec.TestField("Fecha de entrega");
                    Rec.TestField("Comentarios Cancelación");
                    Rec.Estado := Rec.Estado::Cancelada;

                    ActControles;
                end;
            }
            action(Realizar)
            {
                Caption = 'Realizar';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = wCambEstado;

                trigger OnAction()
                begin

                    Rec.TestField("Fecha de entrega");
                    Rec.TestField("Comentarios Entrega");

                    ValidaDistrCC;

                    Rec.Estado := Rec.Estado::Realizada;

                    ActControles;
                end;
            }
            action("<Action1000000029>")
            {
                Caption = 'Cargar Ped. Venta';
                Image = CopyDocument;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    fPed: Page "Sales Order Archives";
                    rPed: Record "Sales Header Archive";
                    rLin: Record "Sales Line Archive";
                    rDetAt: Record "Detalle Atenciones";
                begin
                    rPed.FilterGroup(2);
                    rPed.SetRange("Document Type", rPed."Document Type"::Order);
                    rPed.FilterGroup(0);
                    fPed.LookupMode(true);
                    fPed.Editable(false);
                    fPed.SetTableView(rPed);
                    if fPed.RunModal = ACTION::LookupOK then begin
                        fPed.GetRecord(rPed);
                        rLin.SetRange(rLin."Document Type", rLin."Document Type"::Order);
                        rLin.SetRange("Document No.", rPed."No.");
                        rLin.SetRange("Version No.", rPed."Version No.");
                        if rLin.FindSet then begin
                            repeat
                                rDetAt.Tipo := rDetAt.Tipo::Pedido;
                                rDetAt."Código Cab. Atención" := Rec.Codigo;
                                rDetAt.Codigo := rLin."No.";
                                rDetAt.Descripción := rLin.Description;
                                rDetAt.Cantidad := rLin.Quantity;
                                rDetAt."Precio Unitario" := rLin."Unit Price";
                                rDetAt."Monto total" := rLin.Quantity * rLin."Unit Price";
                                rDetAt.Insert(true);
                            until rLin.Next = 0;
                            Message(Text001);
                        end;
                    end
                    else
                        Error(Text002);
                end;
            }
            action("<Action1000000030>")
            {
                Caption = 'Cargar Ped. Transferencia';
                Image = CopyDocument;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    fPed: Page "Posted Transfer Shipments";
                    rPed: Record "Transfer Shipment Header";
                    rLin: Record "Transfer Shipment Line";
                    rDetAt: Record "Detalle Atenciones";
                    //rSalesPrice: Record "Sales Price";
                    rSalesPrice: Record "Price List Line";
                begin
                    fPed.LookupMode(true);
                    fPed.Editable(false);
                    fPed.SetTableView(rPed);
                    if fPed.RunModal = ACTION::LookupOK then begin
                        fPed.GetRecord(rPed);
                        rLin.SetRange("Document No.", rPed."No.");
                        if rLin.FindSet then begin
                            repeat
                                rDetAt.Tipo := rDetAt.Tipo::Pedido;
                                rDetAt."Código Cab. Atención" := Rec.Codigo;
                                rDetAt.Codigo := rLin."Item No.";
                                rDetAt.Descripción := rLin.Description;
                                rDetAt.Cantidad := rLin.Quantity;
                                rSalesPrice.Reset;
                                rSalesPrice.SetRange(rSalesPrice."Product No.", rLin."Item No.");
                                rSalesPrice.SetRange("Asset Type", rSalesPrice."Asset Type"::Item);
                                if rSalesPrice.FindLast then
                                    rDetAt."Precio Unitario" := rSalesPrice."Unit Price";
                                rDetAt."Monto total" := rDetAt.Cantidad * rDetAt."Precio Unitario";
                                rDetAt.Insert(true);
                            until rLin.Next = 0;
                            Message(Text001);
                        end;
                    end
                    else
                        Error(Text002);
                end;
            }
            action("&Estadística")
            {
                Caption = '&Estadística';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.CalcFields(Monto, Atenciones);
                    Message(StrSubstNo(Text003, Rec.Monto, Rec.Atenciones));
                end;
            }
            action("Distribuc. por Centro de costos")
            {
                Caption = 'Distribuc. por Centro de costos';
                Image = GLAccountBalance;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Atenciones - Grupos de Negocio";
                RunPageLink = "No. Atención" = FIELD(Codigo);
            }
        }
    }

    trigger OnOpenPage()
    begin
        ActControles;
    end;

    var
        Text001: Label 'Las lineas del pedido han sido cargadas con éxito.';
        Text002: Label 'Accion cancelada por el usuario.';
        Text003: Label 'Monto total: %1.\Atenciones: %2.';
        wMod: Boolean;
        wCambEstado: Boolean;


    procedure ActControles()
    begin

        wMod := true;
        if Rec.Estado = Rec.Estado::Realizada then
            wMod := false;

        wCambEstado := false;
        if Rec.Estado = Rec.Estado::Entregada then
            wCambEstado := true;
    end;


    procedure ValidaDistrCC()
    var
        Distr: Record "Atenciones -Dis. Centros Costo";
        Err001: Label 'Debe realizar la distribución de los centros de costo';
        Err002: Label 'No se han realizado la distribución de los centros de costo correctamente';
        Porc: Decimal;
    begin

        Distr.SetRange(Distr."No. Atención", Rec.Codigo);
        if not Distr.FindSet then
            Error(Err001);

        repeat
            Porc += Distr.Porcentaje;
        until Distr.Next = 0;

        if Porc <> 100 then
            Error(Err002);
    end;
}

#pragma implicitwith restore

