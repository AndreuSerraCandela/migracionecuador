report 76290 "CDS Docentes por promotor"
{
    // 0009 CAT Modifiaciones en el formato del informe
    DefaultLayout = RDLC;
    RDLCLayout = './CDSDocentesporpromotor.rdlc';


    dataset
    {
        dataitem("Colegio - Docentes"; "Colegio - Docentes")
        {
            CalcFields = "Nombre Promotor";
            DataItemTableView = SORTING("Pertenece al CDS", "Cod. Colegio", "Apellido paterno") WHERE("Pertenece al CDS" = CONST(true));
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; CompanyName)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Cod__Promotor___________Nombre_Promotor_; "Cod. Promotor" + ' - ' + "Nombre Promotor")
            {
            }
            column(texNombre; texNombre)
            {
            }
            column(TraerDescripcionCargo; TraerDescripcionCargo)
            {
            }
            column(Colegio___Docentes__Cod__Nivel_; "Cod. Nivel")
            {
            }
            column(codCDS; codCDS)
            {
            }
            column(texDocumento; texDocumento)
            {
            }
            column(texTelefono1; texTelefono1)
            {
            }
            column(texTelefono2; texTelefono2)
            {
            }
            column(texEmail; texEmail)
            {
            }
            column(Colegio___Docentes__Cod__Colegio_; "Cod. Colegio")
            {
            }
            column(Colegio___Docentes__Nombre_colegio_; "Nombre colegio")
            {
            }
            column(Colegio___Docentes__Distrito_colegio_; "Distrito colegio")
            {
            }
            column(intTotalGeneral; intTotalGeneral)
            {
            }
            column(Colegio___DocentesCaption; Colegio___DocentesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(texNombreCaption; texNombreCaptionLbl)
            {
            }
            column(TraerDescripcionCargoCaption; TraerDescripcionCargoCaptionLbl)
            {
            }
            column(Colegio___Docentes__Cod__Nivel_Caption; Colegio___Docentes__Cod__Nivel_CaptionLbl)
            {
            }
            column(codCDSCaption; codCDSCaptionLbl)
            {
            }
            column(texDocumentoCaption; texDocumentoCaptionLbl)
            {
            }
            column(texTelefono1Caption; texTelefono1CaptionLbl)
            {
            }
            column(texTelefono2Caption; texTelefono2CaptionLbl)
            {
            }
            column(texEmailCaption; texEmailCaptionLbl)
            {
            }
            column(Colegio___Docentes__Cod__Colegio_Caption; FieldCaption("Cod. Colegio"))
            {
            }
            column(Colegio___Docentes__Nombre_colegio_Caption; FieldCaption("Nombre colegio"))
            {
            }
            column(Colegio___Docentes__Distrito_colegio_Caption; FieldCaption("Distrito colegio"))
            {
            }
            column(Cod__Colegio___________Nombre_colegio__________traerDistritoCaption; Cod__Colegio___________Nombre_colegio__________traerDistritoCaptionLbl)
            {
            }
            column(COUNTCaption; COUNTCaptionLbl)
            {
            }
            column(Colegio___Docentes_Cod__Local; "Cod. Local")
            {
            }
            column(Colegio___Docentes_Cod__Docente; "Cod. Docente")
            {
            }
            column(Colegio___Docentes_Cod__Promotor; "Cod. Promotor")
            {
            }

            trigger OnAfterGetRecord()
            begin

                Clear(texSaludo);
                Clear(codCDS);
                Clear(texNombre);
                Clear(texDocumento);
                Clear(texTelefono1);
                Clear(texTelefono2);
                Clear(texEmail);
                Clear(datFechaNac);
                Clear(codAño);

                if recDocente.Get("Cod. Docente") then begin
                    if recSaludos.Get(recDocente."Salutation Code") then
                        texSaludo := recSaludos.Description;

                    //+0009
                    //codCDS := recDocente."Cod. CDS";
                    if recDocente."No." <> '' then
                        Evaluate(codCDS, recDocente."No.");
                    //-0009

                    texNombre := recDocente.GetApellidosNombre;
                    texDocumento := recDocente."Tipo documento" + ' ' + recDocente."Document ID";
                    texTelefono1 := recDocente."Phone No.";
                    texTelefono2 := recDocente."Mobile Phone No.";
                    texEmail := recDocente."E-Mail";
                    if (recDocente."Dia Nacimiento" <> 0) and (recDocente."Mes Nacimiento" <> 0) and (recDocente."Ano Nacimiento" <> 0) then
                        datFechaNac := DMY2Date(recDocente."Dia Nacimiento", recDocente."Mes Nacimiento", recDocente."Ano Nacimiento");
                    codAño := recDocente."Ano inscripcion CDS";
                end;

                intTotalGeneral += 1;
            end;

            trigger OnPreDataItem()
            begin
                case optOrden of
                    optOrden::Docente:
                        SetCurrentKey("Pertenece al CDS", "Cod. Promotor", "Apellido paterno");
                    optOrden::Colegio:
                        SetCurrentKey("Pertenece al CDS", "Cod. Promotor", "Cod. Colegio");
                    optOrden::Distrito:
                        SetCurrentKey("Pertenece al CDS", "Cod. Promotor", "Distrito colegio");
                end;

                if codPromotor <> '' then
                    SetRange("Cod. Promotor", codPromotor);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Orden; optOrden)
                {
                ApplicationArea = All;
                    OptionCaption = 'Por nombre docente,Por código colegio,Por distrito';
                }
                field(Promotor; codPromotor)
                {
                ApplicationArea = All;
                    TableRelation = "Salesperson/Purchaser";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        recDocente: Record Docentes;
        recSaludos: Record Salutation;
        codPromotor: Code[20];
        optOrden: Option Docente,Colegio,Distrito;
        texSaludo: Text[30];
        codCDS: Integer;
        texNombre: Text[250];
        "codAño": Code[4];
        datFechaNac: Date;
        texDocumento: Text[60];
        texTelefono1: Text[30];
        texTelefono2: Text[30];
        texEmail: Text[80];
        intTotalGeneral: Integer;
        Colegio___DocentesCaptionLbl: Label 'CDS Docentes por promotor';
        CurrReport_PAGENOCaptionLbl: Label 'Pág.';
        texNombreCaptionLbl: Label 'Nombre docente';
        TraerDescripcionCargoCaptionLbl: Label 'Cargo';
        Colegio___Docentes__Cod__Nivel_CaptionLbl: Label 'Cód. Nivel';
        codCDSCaptionLbl: Label 'Código CDS';
        texDocumentoCaptionLbl: Label 'Documento';
        texTelefono1CaptionLbl: Label 'Teléfono';
        texTelefono2CaptionLbl: Label 'Teléfono 2';
        texEmailCaptionLbl: Label 'Email';
        Cod__Colegio___________Nombre_colegio__________traerDistritoCaptionLbl: Label 'Promotor:';
        COUNTCaptionLbl: Label 'Total general:';


    procedure TraerDescripcionCargo(): Text[100]
    var
        recDatAux: Record "Datos auxiliares";
    begin
        recDatAux.Reset;
        recDatAux.SetRange("Tipo registro", recDatAux."Tipo registro"::"Puestos de trabajo");
        recDatAux.SetRange(Codigo, "Colegio - Docentes"."Cod. Cargo");
        if recDatAux.FindFirst then
            exit(recDatAux.Descripcion);
    end;


    procedure traerDistrito(): Text[30]
    var
        recColegio: Record Contact;
    begin
        if recColegio.Get("Colegio - Docentes"."Cod. Colegio") then
            exit(recColegio.Distritos);
    end;


    procedure FormatFechaNac()
    begin
    end;
}

