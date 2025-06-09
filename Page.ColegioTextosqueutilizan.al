#pragma implicitwith disable
page 76145 "Colegio - Textos que utilizan"
{
    ApplicationArea = all;
    Editable = false;
    PageType = List;
    SourceTable = "Historico Adopciones";
    SourceTableView = SORTING("Cod. Colegio", Campana, Adopcion, "Cod. Editorial");

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Campana; rec.Campana)
                {
                }
                field("Cod. Editorial"; rec."Cod. Editorial")
                {
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Cod. Grado"; rec."Cod. Grado")
                {
                }
                field("Cod. Turno"; rec."Cod. Turno")
                {
                }
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                }
                field(Seccion; rec.Seccion)
                {
                }
                field("Cod. Equiv. Santillana"; rec."Cod. Equiv. Santillana")
                {
                }
                field("Descripcion Equiv. Santillana"; rec."Descripcion Equiv. Santillana")
                {
                }
                field("Nombre Editorial"; rec."Nombre Editorial")
                {
                }
                field("Cod. producto"; rec."Cod. producto")
                {
                }
                field("Cod. Producto Editora"; rec."Cod. Producto Editora")
                {
                }
                field("Nombre Producto Editora"; rec."Nombre Producto Editora")
                {
                }
                field("Nombre Libro"; rec."Nombre Libro")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                }
                field("Descripcion Nivel"; rec."Descripcion Nivel")
                {
                }
                field("Descripcion Grado"; rec."Descripcion Grado")
                {
                }
                field("Fecha Adopcion"; rec."Fecha Adopcion")
                {
                }
                field("Cantidad Alumnos"; rec."Cantidad Alumnos")
                {
                }
                field("Linea de negocio"; rec."Linea de negocio")
                {
                }
                field(Familia; rec.Familia)
                {
                }
                field("Sub Familia"; rec."Sub Familia")
                {
                }
                field(Adopcion; rec.Adopcion)
                {
                }
                field("% Dto. Padres de familia"; rec."% Dto. Padres de familia")
                {
                }
                field("% Dto. Colegio"; rec."% Dto. Colegio")
                {
                }
                field("% Dto. Docente"; rec."% Dto. Docente")
                {
                }
                field("% Dto. Feria Padres de familia"; rec."% Dto. Feria Padres de familia")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Textos)
            {
                Caption = 'Textos';
                action("<Action1000000020>")
                {
                    Caption = 'Ver Solo Adopciones';
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        verAdopciones;
                    end;
                }
                action("<Action1000000022>")
                {
                    Caption = 'Ver Solo Competencias';
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        verCompetencias;
                    end;
                }
            }
        }
    }


    procedure verAdopciones()
    begin
        Rec.SetFilter(Adopcion, '<>%1', 0);
        Rec.SetRange("Cod. Editorial");
    end;


    procedure verCompetencias()
    begin
        Rec.SetRange(Adopcion);
        Rec.SetFilter("Cod. Editorial", '<>%1', '');
    end;
}

#pragma implicitwith restore

