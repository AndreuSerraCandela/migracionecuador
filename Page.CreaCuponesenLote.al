#pragma implicitwith disable
page 56069 "Crea Cupones en Lote"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Crear Cupon por Lote.";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Cod. Colegio"; Rec."Cod. Colegio")
                {

                    trigger OnValidate()
                    begin
                        if rContacto.Get(Rec."Cod. Colegio") then begin
                            NombreColegio := rContacto.Name;
                            DescuentoAColegio := rContacto."% Descuento Cupon";
                            //CodVendedor := rContacto."Salesperson Code";
                            if rSalesperson.Get(CodVendedor) then
                                NombreVendedor := rSalesperson.Name
                            else
                                NombreVendedor := '';
                        end;
                    end;
                }
                field(NombreColegio; NombreColegio)
                {
                    Caption = 'School Name';
                    Editable = false;
                }
                field("Cod. Nivel"; Rec."Cod. Nivel")
                {
                }
                field("Cod. Promotor"; Rec."Cod. Promotor")
                {

                    trigger OnValidate()
                    begin
                        if rSalesperson.Get(Rec."Cod. Promotor") then
                            NombreVendedor := rSalesperson.Name
                        else
                            NombreVendedor := '';

                        AH.Reset;
                        AH.SetRange("Cod. Colegio", Rec."Cod. Colegio");
                        AH.SetRange("Cod. Nivel", Rec."Cod. Nivel");
                        AH.SetRange("Cod. Promotor", Rec."Cod. Promotor");
                        if AH.FindFirst then begin
                            Rec.Validate("% Descuento Padre", AH."% Dto. Padres");
                            Rec.Validate("% Descuento Colegio", AH."% Dto. Colegio");
                        end;
                    end;
                }
                field(NombreVendedor; NombreVendedor)
                {
                    Caption = 'Nombre Vendedor';
                    Editable = false;
                }
                field("Cod. Grado"; Rec."Cod. Grado")
                {

                    trigger OnValidate()
                    begin
                        if DatAux.Get(DatAux."Tipo registro"::Grados, Rec."Cod. Grado") then
                            DescGrado := DatAux.Descripcion
                        else
                            DescGrado := '';
                    end;
                }
                field(DescGrado; DescGrado)
                {
                    Caption = 'Grade Description';
                    Editable = false;
                }
                field(Turno; Rec.Turno)
                {
                    Visible = false;
                }
                field(AnoEscolar; AnoEscolar)
                {
                    Caption = 'Campaing';
                    Editable = false;
                    TableRelation = Campaign."No.";
                    Visible = false;

                    trigger OnValidate()
                    begin
                        if Camp.Get(AnoEscolar) then begin
                            ValidaDesde := Camp."Starting Date";
                            ValidaHasta := Camp."Ending Date";
                        end;
                    end;
                }
                field(CodColegio; CodColegio)
                {
                    Caption = 'School Code';
                    Editable = false;
                    TableRelation = "Colegio - Adopciones Cab"."Cod. Colegio";
                    Visible = false;

                    trigger OnValidate()
                    begin
                        if rContacto.Get(CodColegio) then begin
                            NombreColegio := rContacto.Name;
                            DescuentoAColegio := rContacto."% Descuento Cupon";
                            //CodVendedor := rContacto."Salesperson Code";
                            if rSalesperson.Get(CodVendedor) then
                                NombreVendedor := rSalesperson.Name
                            else
                                NombreVendedor := '';
                        end;
                    end;
                }
                field(GradoAlumno; GradoAlumno)
                {
                    Caption = 'Student Grade';
                    Editable = false;
                    TableRelation = "Colegio - Nivel"."Cod. Nivel";
                    Visible = false;
                }
                field(txtDescripcion; txtDescripcion)
                {
                    Caption = 'Description';
                }
                field("% Descuento Padre"; Rec."% Descuento Padre")
                {
                    Caption = 'School Discount';
                }
                field("% Descuento Colegio"; Rec."% Descuento Colegio")
                {
                    Caption = 'Parents Discounts';
                }
                field(ValidaDesde; ValidaDesde)
                {
                    Caption = 'Valid From';
                }
                field(ValidaHasta; ValidaHasta)
                {
                    Caption = 'Valid To:';
                }
                field(CodVendedor; CodVendedor)
                {
                    Caption = 'Salesperson Code';
                    Editable = false;
                    TableRelation = "Salesperson/Purchaser";
                    Visible = false;

                    trigger OnValidate()
                    begin
                        if rSalesperson.Get(CodVendedor) then
                            NombreVendedor := rSalesperson.Name
                        else
                            NombreVendedor := '';
                    end;
                }
                field(CantidadCupones; CantidadCupones)
                {
                    Caption = 'Coupons Qty.';
                }
            }
            part(Lineas; "Lin. Crea Cup. Lote")
            {
                SubPageView = SORTING("Cod. Producto")
                              ORDER(Ascending)
                              WHERE("Cod. Producto" = FILTER(<> ''));
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Generar")
            {
                Caption = '&Generate';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    cuFunSantillana.cuCreaCupones(Rec."Cod. Colegio", Rec."Cod. Promotor", NombreVendedor, ValidaDesde, ValidaHasta, Rec."Cod. Grado",
                                                  Rec."% Descuento Colegio", Rec."% Descuento Padre", AnoEscolar, NombreColegio, txtDescripcion, CantidadCupones,
                                                  Rec."Cod. Nivel", DescGrado);
                end;
            }
            action("&Traer Líneas de Adopción")
            {
                Caption = '&Get Lines From Adoptions';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    AL.Reset;
                    AL.SetRange("Cod. Colegio", Rec."Cod. Colegio");
                    AL.SetRange("Cod. Nivel", Rec."Cod. Nivel");
                    AL.SetRange("Cod. Promotor", Rec."Cod. Promotor");
                    AL.SetRange("Cod. Grado", Rec."Cod. Grado");
                    if AL.FindSet then
                        repeat
                            CCPL.Init;
                            if AL."Cod. Producto" <> '' then begin
                                CantidadCupones := AL."Cantidad Alumnos";
                                CCPL.Validate("Cod. Producto", AL."Cod. Producto");
                                CCPL.Validate(Descripcion, AL."Descripcion producto");
                                CCPL.Validate("% Descuento Padre", AL."% Dto. Padres");
                                CCPL.Validate("% Descuento Colegio", AL."% Dto. Colegio");
                                CCPL.Validate(Cantidad, 1);
                                CCPL.Validate("Cod. Colegio", AL."Cod. Colegio");
                                CCPL.Validate("Cod. Nivel", AL."Cod. Nivel");
                                CCPL.Validate("Cod. Promotor", AL."Cod. Promotor");
                                CCPL.Validate("Cod. Grado", AL."Cod. Grado");
                                CCPL.Insert;
                            end;
                        until AL.Next = 0;
                    CurrPage.Update;
                end;
            }
            action("&Importar Líneas")
            {
                Image = ImportExport;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ImportaLineas.RunModal;
                    CurrPage.Update;
                end;
            }
        }
    }

    trigger OnClosePage()
    begin
        Rec.DeleteAll;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."% Descuento Padre" := DescAPadre;
        Rec.Validate(Cantidad, 1);
    end;

    var
        CodColegio: Code[20];
        CodVendedor: Code[20];
        NombreVendedor: Text[100];
        ValidaDesde: Date;
        ValidaHasta: Date;
        GradoAlumno: Text[30];
        DescuentoAColegio: Decimal;
        DescAPadre: Decimal;
        AnoEscolar: Text[30];
        NombreColegio: Text[100];
        rSalesperson: Record "Salesperson/Purchaser";
        rContacto: Record Contact;
        CantidadCupones: Integer;
        I: Integer;
        rCabCupon: Record "Cab. Cupon.";
        rLinCupon: Record "Lin. Cupon.";
        Window: Dialog;
        CounterTotal: Integer;
        Counter: Integer;
        CounterOK: Integer;
        rConfEmpresa: Record "Config. Empresa";
        rCreaCupLot: Record "Crear Cupon por Lote";
        rCabCupon1: Record "Cab. Cupon.";
        rAnoEscolar: Record "Año Escolar.";
        rCrearCuponPorLote: Record "Crear Cupon por Lote";
        NoSeries: Code[20];
        rVendPorColegio: Record "Vendedores por Colegio";
        txtDescripcion: Text[250];
        txtDescrAnulacion: Text[250];
        cuFunSantillana: Codeunit "Funciones Santillana";
        Camp: Record Campaign;
        Adopcion: Code[20];
        ConfAPS: Record "Commercial Setup";
        AH: Record "Colegio - Adopciones Cab";
        AL: Record "Colegio - Adopciones Detalle";
        CCPL: Record "Crear Cupon por Lote.";
        DescGrado: Text[50];
        DatAux: Record "Datos auxiliares";
        ImportaLineas: Report "Imp. Lineas Cupon";
}

#pragma implicitwith restore

