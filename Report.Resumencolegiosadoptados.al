report 76321 "Resumen colegios adoptados"
{
    // Falta calcujlo de colegios adoptados , no adoptados e indecisos. Ademas del nº de ejemplares.
    DefaultLayout = RDLC;
    RDLCLayout = './Resumencolegiosadoptados.rdlc';


    dataset
    {
        dataitem(CategoriasPromotor; "Colegio - Nivel")
        {
            DataItemTableView = SORTING("Cod. Promotor", "Categoria colegio") WHERE("Cod. Promotor" = FILTER(<> ''));
            RequestFilterFields = "Cod. Promotor", "Categoria colegio";
            RequestFilterHeading = 'Resumen de colegios adoptados por categoría';
            column(USERID; UserId)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(intColegios; intColegios)
            {
            }
            column(CategoriasPromotor__Categoria_colegio_; "Categoria colegio")
            {
            }
            column(TraerNombrePromotor; TraerNombrePromotor)
            {
            }
            column(CategoriasPromotor__Cod__Promotor_; "Cod. Promotor")
            {
            }
            column(intNoAdoptados; intNoAdoptados)
            {
            }
            column(intAdoptados; intAdoptados)
            {
            }
            column(intFaltanDecidir; intFaltanDecidir)
            {
            }
            column(intEjemplares; intEjemplares)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column("Resumen_de_colegios_adoptados_por_categoríaCaption"; Resumen_de_colegios_adoptados_por_categoríaCaptionLbl)
            {
            }
            column(intColegiosCaption; intColegiosCaptionLbl)
            {
            }
            column(CategoriasPromotor__Categoria_colegio_Caption; CategoriasPromotor__Categoria_colegio_CaptionLbl)
            {
            }
            column(TraerNombrePromotorCaption; TraerNombrePromotorCaptionLbl)
            {
            }
            column(CategoriasPromotor__Cod__Promotor_Caption; FieldCaption("Cod. Promotor"))
            {
            }
            column(No_adoptadosCaption; No_adoptadosCaptionLbl)
            {
            }
            column(AdoptadosCaption; AdoptadosCaptionLbl)
            {
            }
            column(Faltan_decidirCaption; Faltan_decidirCaptionLbl)
            {
            }
            column(EjemplaresCaption; EjemplaresCaptionLbl)
            {
            }
            column(CategoriasPromotor_Cod__Colegio; "Cod. Colegio")
            {
            }
            column(CategoriasPromotor_Cod__Nivel; "Cod. Nivel")
            {
            }
            column(CategoriasPromotor_Turno; Turno)
            {
            }
            column(CategoriasPromotor_Ruta; Ruta)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(intAdoptados);
                Clear(intNoAdoptados);
                Clear(intFaltanDecidir);
                Clear(intEjemplares);
                Clear(intColegios);

                FilterGroup(2);
                SetRange("Cod. Promotor", "Cod. Promotor");
                SetRange("Categoria colegio", "Categoria colegio");
                FindLast;
                SetRange("Cod. Promotor");
                SetRange("Categoria colegio");

                recTmpColegio.DeleteAll;

                recNivelCol.Reset;
                recNivelCol.SetCurrentKey("Cod. Promotor", "Categoria colegio");
                recNivelCol.SetRange("Cod. Promotor", CategoriasPromotor."Cod. Promotor");
                recNivelCol.SetRange("Categoria colegio", CategoriasPromotor."Categoria colegio");
                if recNivelCol.FindSet then
                    repeat
                        recNivelCol.SetRange("Cod. Colegio", recNivelCol."Cod. Colegio");
                        recNivelCol.FindLast;
                        recNivelCol.SetRange("Cod. Colegio");

                        intColegios += 1;

                        //Colegios NO adoptados
                        recAdopcion.Reset;
                        recAdopcion.SetCurrentKey("Cod. Colegio", "Cod. Nivel");
                        recAdopcion.SetRange("Cod. Colegio", recNivelCol."Cod. Colegio");
                        recAdopcion.SetRange("Cod. Nivel", recNivelCol."Cod. Nivel");
                        recAdopcion.SetRange("Cod. Promotor", recNivelCol."Cod. Promotor");
                        if not recAdopcion.FindFirst then
                            intNoAdoptados += 1
                        else begin
                            //Colegios adoptados
                            recAdopcion.Reset;
                            recAdopcion.SetCurrentKey("Cod. Colegio", "Cod. Nivel");
                            recAdopcion.SetRange("Cod. Colegio", recNivelCol."Cod. Colegio");
                            recAdopcion.SetRange("Cod. Nivel", recNivelCol."Cod. Nivel");
                            recAdopcion.SetRange("Cod. Promotor", recNivelCol."Cod. Promotor");
                            recAdopcion.SetFilter(Adopcion, '%1|%2', recAdopcion.Adopcion::Conquista, recAdopcion.Adopcion::Mantener);
                            if recAdopcion.FindSet then begin
                                intAdoptados += 1;
                                repeat
                                    intEjemplares += recAdopcion."Adopcion Real"
                                until recAdopcion.Next = 0;
                            end
                            else begin
                                recAdopcion.SetRange(Adopcion, recAdopcion.Adopcion::Perdida);  //Colegios NO adoptados
                                if recAdopcion.FindFirst then
                                    intNoAdoptados += 1
                                else begin
                                    recAdopcion.SetRange(Adopcion, recAdopcion.Adopcion::" ");    //Colegios sin decidir
                                    if recAdopcion.FindFirst then
                                        intFaltanDecidir += 1
                                end;
                            end;
                        end;

                    until recNivelCol.Next = 0;
            end;
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

    labels
    {
    }

    var
        Text001: Label 'Cargando datos';
        Text002: Label '##############################1\\';
        Text003: Label '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2';
        recNivelCol: Record "Colegio - Nivel";
        recTmpColegio: Record Contact temporary;
        recAdopcion: Record "Colegio - Adopciones Detalle";
        intColegios: Integer;
        intNoAdoptados: Integer;
        intAdoptados: Integer;
        intFaltanDecidir: Integer;
        intEjemplares: Decimal;
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        "Resumen_de_colegios_adoptados_por_categoríaCaptionLbl": Label 'Resumen de colegios adoptados por categoría';
        intColegiosCaptionLbl: Label 'Total colegios';
        CategoriasPromotor__Categoria_colegio_CaptionLbl: Label 'Categoría';
        TraerNombrePromotorCaptionLbl: Label 'Nombre promotor';
        No_adoptadosCaptionLbl: Label 'No adoptados';
        AdoptadosCaptionLbl: Label 'Adoptados';
        Faltan_decidirCaptionLbl: Label 'Faltan decidir';
        EjemplaresCaptionLbl: Label 'Ejemplares';


    procedure TraerNombrePromotor(): Text[50]
    var
        recPromotor: Record "Salesperson/Purchaser";
    begin
        if recPromotor.Get(CategoriasPromotor."Cod. Promotor") then
            exit(recPromotor.Name);
    end;
}

