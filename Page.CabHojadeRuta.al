#pragma implicitwith disable
page 56009 "Cab. Hoja de Ruta"
{
    ApplicationArea = all;
    PageType = Document;
    SourceTable = "Cab. Hoja de Ruta";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No. Hoja Ruta"; rec."No. Hoja Ruta")
                {
                }
                field("Cod. Transportista"; rec."Cod. Transportista")
                {
                }
                field("Nombre Chofer"; rec."Nombre Chofer")
                {
                    Editable = false;
                }
                field(Ayudantes; rec.Ayudantes)
                {
                    Caption = 'Ayudantes';
                }
                field("Fecha Planificacion Transporte"; rec."Fecha Planificacion Transporte")
                {
                }
                field(Almacen; rec.Almacen)
                {
                    Caption = 'Almacen';
                }
                field(Zona; rec.Zona)
                {
                }
                field(Comentario; rec.Comentario)
                {
                }
                field("Cantidad de cajas"; rec."Cantidad de cajas")
                {
                }
            }
            part(Control1000000006; "Lin. Hoja de Ruta")
            {
                SubPageLink = "No. Hoja Ruta" = FIELD("No. Hoja Ruta");
                SubPageView = SORTING("No. Hoja Ruta", "No. Linea")
                              ORDER(Ascending);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Generate Guide Number")
            {
                Caption = '&Generate Guide Number';
                Promoted = true;
                PromotedCategory = Process;
            }
            group("<Action1000000009>")
            {
                Caption = '&Post';
                action("<Action1000000010>")
                {
                    Caption = '&Registrar';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Confirm(txt001) then
                            FunSant.RegHojaEnv(Rec, false);
                    end;
                }
                action("&Post And Print")
                {
                    Caption = '&Post And Print';
                    InFooterBar = true;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Confirm(txt002) then
                            FunSant.RegHojaEnv(Rec, true);
                    end;
                }
                action("<Action1000000015>'")
                {
                    Caption = 'Solo Imprimir';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        recHojaRuta: Record "Cab. Hoja de Ruta";
                    begin
                        recHojaRuta.Get(Rec."No. Hoja Ruta");
                        recHojaRuta.SetRecFilter;
                        REPORT.Run(REPORT::"Hoja de Ruta No Registrada", true, false, recHojaRuta);
                    end;
                }
            }
        }
    }

    var
        LHR: Record "Lin. Hoja de Ruta";
        CHRR: Record "Cab. Hoja de Ruta Reg.";
        LHRR: Record "Lin. Hoja de Ruta Reg.";
        SRS: Record "Sales & Receivables Setup";
        txt001: Label 'Confirm that you want to post the Route Sheet';
        txt002: Label 'Confirm that you want to Post and Print the Route Sheet';
        LHRR1: Record "Lin. Hoja de Ruta Reg.";
        FunSant: Codeunit "Funciones Santillana";
}

#pragma implicitwith restore

