#pragma implicitwith disable
page 76136 "Colegio - Adopciones Detalles"
{
    ApplicationArea = all;
    PageType = ListPart;
    SourceTable = "Colegio - Adopciones Detalle";

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
                    Visible = false;
                }
                field("Cod. Producto Editora"; rec."Cod. Producto Editora")
                {
                }
                field("Nombre Producto Editora"; rec."Nombre Producto Editora")
                {
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                    Editable = false;
                }
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                    Editable = false;
                }
                field("Descripcion producto"; rec."Descripcion producto")
                {
                    Editable = false;
                }
                field("Cod. Turno"; rec."Cod. Turno")
                {
                    Editable = false;
                }
                field("Cod. Grado"; rec."Cod. Grado")
                {
                }
                field("Grupo de Negocio"; rec."Grupo de Negocio")
                {
                    Editable = false;
                }
                field("Cod. Producto"; rec."Cod. Producto")
                {
                }
                field(Seccion; rec.Seccion)
                {
                }
                field("Fecha Adopcion"; rec."Fecha Adopcion")
                {
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Descripcion Nivel"; rec."Descripcion Nivel")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Adopcion anterior"; rec."Adopcion anterior")
                {
                    Editable = false;
                }
                field(Adopcion; rec.Adopcion)
                {
                }
                field("Mes de Lectura"; rec."Mes de Lectura")
                {
                }
                field("Fecha de lectura"; rec."Fecha de lectura")
                {
                }
                field("Cantidad Alumnos"; rec."Cantidad Alumnos")
                {
                    Editable = false;
                }
                field("Adopcion Real"; rec."Adopcion Real")
                {
                }
                field("% Dto. Padres"; rec."% Dto. Padres")
                {
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                    Editable = false;
                    Visible = false;
                }
                field("% Dto. Colegio"; rec."% Dto. Colegio")
                {
                }
                field("% Dto. Docente"; rec."% Dto. Docente")
                {
                }
                field("% Dto. Feria Padres"; rec."% Dto. Feria Padres")
                {
                }
                field("% Dto. Feria Colegio"; rec."% Dto. Feria Colegio")
                {
                }
                field("Cod. Motivo perdida adopcion"; rec."Cod. Motivo perdida adopcion")
                {
                }
                field("Linea de negocio"; rec."Linea de negocio")
                {
                    Editable = false;
                }
                field("Sub Familia"; rec."Sub Familia")
                {
                    Editable = false;
                }
                field(Serie; rec.Serie)
                {
                    Editable = false;
                }
                field(Inventory; rec.Inventory)
                {
                }
                field("Unit Price"; rec."Unit Price")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000016>")
            {
                Caption = '&Actions';
                action(FProd)
                {
                    Caption = '&Item Card';
                    Image = Edit;
                    ShortCutKey = 'Shift+F5';

                    trigger OnAction()
                    begin
                        FichaProducto;
                    end;
                }
                separator(Action1000000010)
                {
                }
                action(AdopComp)
                {
                    Caption = 'Competency Items';
                    Image = BulletList;

                    trigger OnAction()
                    begin
                        AdopCompetencia;
                    end;
                }
            }
        }
    }

    var
        HAdopciones: Record "Historico Adopciones";
        Item: Record Item;
        PptoPromotor: Record "Promotor - Ppto Vtas";
        TempAdopciones: Record "Colegio - Log - Adopciones" temporary;
        GradosCol: Record "Colegio - Grados";
        Editoriales: Record Editoras;
        NoMov: Integer;
        gCodCol: Code[20];
        gCodNivel: Code[20];
        gCodPromotor: Code[20];
        gCodRuta: Code[20];
        gCodTurno: Code[20];
        gCodLocal: Code[20];
        Ano: Integer;


    procedure UpdForm()
    begin
        Rec.SetCurrentKey("Cod. Colegio", "Grupo de Negocio", Serie, "Cod. Producto");
        CurrPage.Update;
    end;


    procedure RecibeFiltro(FiltroFecha: Date; FiltroLinNeg: Text[250]; FiltroGpoNeg: Text[250]; FiltroNivel: Text[250]; FiltroSerie: Text[250]; FiltroSubFam: Text[250])
    begin
        /*
        if filtrofecha <> 0d then
           setrange
        */

        Rec.Reset;

        if FiltroLinNeg <> '' then
            Rec.SetFilter("Linea de negocio", FiltroLinNeg);

        if FiltroNivel <> '' then
            Rec.SetFilter("Cod. Nivel", FiltroNivel);

        if FiltroGpoNeg <> '' then
            Rec.SetFilter("Grupo de Negocio", FiltroGpoNeg);

        if FiltroSerie <> '' then
            Rec.SetFilter(Serie, FiltroSerie);

        if FiltroSubFam <> '' then
            Rec.SetFilter("Sub Familia", FiltroSubFam);
        //MESSAGE('%1',GETFILTERS);

        //UpdForm;

    end;


    procedure FichaProducto()
    var
        ItemCard: Page "Item Card";
    begin
        Rec.OpenItem;
    end;


    procedure AdopCompetencia()
    var
        ColAdopCompet: Record "Colegio - Adopciones compet.";
        fColAdopCompet: Page "Colegio - Adopciones compet.";
        ColAdopDet: Record "Colegio - Adopciones Detalle";
    begin
        fColAdopCompet.RecibeParametros(Rec."Cod. Colegio", Rec."Cod. Promotor", Rec."Cod. Producto", Rec."Cod. Nivel", Rec."Cod. Grado");
        fColAdopCompet.Run;
        Clear(fColAdopCompet);
    end;
}

#pragma implicitwith restore

