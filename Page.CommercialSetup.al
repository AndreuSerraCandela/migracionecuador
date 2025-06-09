page 76012 "Commercial Setup"
{
    ApplicationArea = all;

    Caption = 'Commercial Setup';
    PageType = Card;
    SourceTable = "Commercial Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Campana; rec.Campana)
                {
                }
                field("Gpo. contable prod. ventas"; rec."Gpo. contable prod. ventas")
                {
                }
                field("Gpo. contable prod. obsequios"; rec."Gpo. contable prod. obsequios")
                {
                }
                field("Ruta archivos electronicos"; rec."Ruta archivos electronicos")
                {
                }
                field("Cod. Alm. Muestras"; rec."Cod. Alm. Muestras")
                {
                }
                field("Campaña Ranking Solicitud"; rec."Campaña Ranking Solicitud")
                {
                }
            }
            group(Dimension)
            {
                Caption = 'Dimension';
                field("Cod. Dimension APS"; rec."Cod. Dimension APS")
                {
                }
                field("Cod. Dimension Lin. Negocio"; rec."Cod. Dimension Lin. Negocio")
                {
                }
                field("Cod. Dimension Familia"; rec."Cod. Dimension Familia")
                {
                }
                field("Cod. Dimension Sub Familia"; rec."Cod. Dimension Sub Familia")
                {
                }
                field("Cod. Dimension Serie"; rec."Cod. Dimension Serie")
                {
                }
                field("Cod. Dimension Delegacion"; rec."Cod. Dimension Delegacion")
                {
                }
                field("Cod. Dimension Dist. Geo."; rec."Cod. Dimension Dist. Geo.")
                {
                }
                field("Dim para Estad. Adopciones"; rec."Dim para Estad. Adopciones")
                {
                }
            }
            group(Numering)
            {
                Caption = 'Numering';
                field("No. Serie Profesores"; rec."No. Serie Profesores")
                {
                }
                field("No. Serie Eventos"; rec."No. Serie Eventos")
                {
                }
                field("No. Serie Talleres"; rec."No. Serie Talleres")
                {
                }
                field("No. Serie CDS"; rec."No. Serie CDS")
                {
                }
                field("No. Serie Atenciones"; rec."No. Serie Atenciones")
                {
                }
                field("No. Serie Visita Asesor/Consu."; rec."No. Serie Visita Asesor/Consu.")
                {
                    Caption = 'No. Serie Visita Asesor/Consultor';
                }
            }
            group("Platilla Word")
            {
                Caption = 'Platilla Word';
                field("Ruta Word sol. asis. tex."; rec."Ruta Word sol. asis. tex.")
                {
                }
                field("Ruta Word ficha de PPFF"; rec."Ruta Word ficha de PPFF")
                {
                }
            }
        }
    }

    actions
    {
    }
}

