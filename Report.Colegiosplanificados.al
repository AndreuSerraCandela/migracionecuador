report 76359 "Colegios planificados"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Colegiosplanificados.rdlc';

    dataset
    {
        dataitem(Planificacion; "Promotor - Planif. Visita")
        {
            CalcFields = "Nombre Promotor";
            DataItemTableView = SORTING(Delegacion, Nivel, "Cod. Promotor", Ano, Semana, "Fecha Visita") WHERE("Fecha Visita" = FILTER(<> 0D));
            RequestFilterFields = Delegacion, Nivel, "Cod. Promotor", "Fecha Visita";
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Delegacion__________TraerNombreDelegacion; Delegacion + ' -  ' + TraerNombreDelegacion)
            {
            }
            column(Nivel_______texDescNivel; Nivel + ' - ' + texDescNivel)
            {
            }
            column(Cod__Promotor__________Nombre_Promotor_; "Cod. Promotor" + ' -  ' + "Nombre Promotor")
            {
            }
            column(Planificacion_Semana; Semana)
            {
            }
            column(Planificacion_Ano; Ano)
            {
            }
            column(TraerDiasSemana; TraerDiasSemana)
            {
            }
            column(Planificacion__Fecha_Visita_; "Fecha Visita")
            {
            }
            column(Planificacion__Nombre_Colegio_; "Nombre Colegio")
            {
            }
            column(texDistrito; texDistrito)
            {
            }
            column(codCategoria; codCategoria)
            {
            }
            column(Planificacion__Descripcion_Objetivo_; "Descripcion Objetivo")
            {
            }
            column(Planificacion__Cod__Colegio_; "Cod. Colegio")
            {
            }
            column("Planificación_de_visitasCaption"; Planificación_de_visitasCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Planificacion__Cod__Colegio_Caption; FieldCaption("Cod. Colegio"))
            {
            }
            column(Planificacion__Nombre_Colegio_Caption; FieldCaption("Nombre Colegio"))
            {
            }
            column(texDistritoCaption; texDistritoCaptionLbl)
            {
            }
            column(codCategoriaCaption; codCategoriaCaptionLbl)
            {
            }
            column(Planificacion__Descripcion_Objetivo_Caption; Planificacion__Descripcion_Objetivo_CaptionLbl)
            {
            }
            column("Delegación_Caption"; Delegación_CaptionLbl)
            {
            }
            column(Nivel_Caption; Nivel_CaptionLbl)
            {
            }
            column(Promotor_Caption; Promotor_CaptionLbl)
            {
            }
            column(Semana_Caption; Semana_CaptionLbl)
            {
            }
            column("Año_Caption"; Año_CaptionLbl)
            {
            }
            column(Planificacion_Cod__Promotor; "Cod. Promotor")
            {
            }
            column(Planificacion_Delegacion; Delegacion)
            {
            }
            column(Planificacion_Nivel; Nivel)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(texDistrito);
                Clear(texDescNivel);

                if recColegio.Get("Cod. Colegio") then
                    texDistrito := recColegio.Distritos;

                if recNivel.Get(Nivel) then
                    texDescNivel := recNivel.Descripción;

                codCategoria := TraerCategoria("Cod. Colegio", Nivel);
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
        recColegio: Record Contact;
        recNivel: Record "Nivel Educativo APS";
        texDistrito: Text[100];
        codCategoria: Code[20];
        Text001: Label 'Del %1 al %2';
        texDescNivel: Text[100];
        "Planificación_de_visitasCaptionLbl": Label 'Planificación de visitas';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        texDistritoCaptionLbl: Label 'Distrito';
        codCategoriaCaptionLbl: Label 'Categoria';
        Planificacion__Descripcion_Objetivo_CaptionLbl: Label 'Objetivo';
        "Delegación_CaptionLbl": Label 'Delegación:';
        Nivel_CaptionLbl: Label 'Nivel:';
        Promotor_CaptionLbl: Label 'Promotor:';
        Semana_CaptionLbl: Label 'Semana:';
        "Año_CaptionLbl": Label 'Año:';


    procedure TraerCategoria(codPrmColegio: Code[20]; codPrmNivel: Code[20]): Code[10]
    var
        recNivel: Record "Colegio - Nivel";
    begin
        recNivel.Reset;
        recNivel.SetRange("Cod. Colegio", codPrmColegio);
        recNivel.SetRange("Cod. Nivel", codPrmNivel);
        if recNivel.FindFirst then
            exit(recNivel."Categoria colegio");
    end;


    procedure TraerDiasSemana(): Text[100]
    var
        recFechas: Record Date;
    begin
        recFechas.Reset;
        recFechas.SetRange("Period Type", recFechas."Period Type"::Week);
        recFechas.SetFilter("Period Start", '<=%1', Planificacion."Fecha Visita");
        recFechas.SetFilter("Period End", '>=%1', Planificacion."Fecha Visita");
        recFechas.SetRange("Period No.", Planificacion.Semana);
        if recFechas.FindFirst then
            exit(StrSubstNo(Text001, Format(recFechas."Period Start", 0, '<Day>/<Month>/<Year4>'),
                                     Format(NormalDate(recFechas."Period End"), 0, '<Day>/<Month>/<Year4>')));
    end;


    procedure TraerNombreDelegacion(): Text[50]
    var
        recCfg: Record "Commercial Setup";
        recDimValue: Record "Dimension Value";
    begin
        recCfg.Get;
        recCfg.TestField("Cod. Dimension Delegacion");

        if recDimValue.Get(recCfg."Cod. Dimension Delegacion", Planificacion.Delegacion) then
            exit(recDimValue.Name);
    end;
}

