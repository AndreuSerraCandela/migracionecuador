report 76230 "Cerrar campaña"
{
    // ------------------------------------------------------------------------
    // No.     Fecha           Firma         Descripcion
    // ------------------------------------------------------------------------
    // 001     17-Julio-14     AMS           Este proceso guarda en el histórico los datos de la campaña actual.
    //                                       El proceso hace lo siguiente:
    // 
    //                                         Copia los datos de Grados al histórico y deja como está la tabla actual.
    //                                         Copia los datos de Adopciones por colegio al histórico y vacía la actual.
    //                                         Copia los datos de Colegios Niveles al histórico y vacía la actual.
    //                                         Vacía la tabla de Promotor-Ruta.
    //                                         Vacía la tabla Ppto de ventas.
    //                                         Vacía la tabla Promotores Lista de Colegios.

    Caption = 'Close Campaign';
    ProcessingOnly = true;

    dataset
    {
        dataitem(ColGrados; "Colegio - Grados")
        {
            DataItemTableView = SORTING("Cod. Colegio", "Cod. Nivel", "Cod. Turno", "Cod. Grado", Seccion);

            trigger OnAfterGetRecord()
            var
                recHistGrados: Record "Historico Colegio - Grados";
            begin
                recHistGrados.Init;
                recHistGrados.TransferFields(ColGrados);
                recHistGrados.Campana := codCampaña;
                recHistGrados.Insert;
            end;
        }
        dataitem(ColDetAdopciones; "Colegio - Adopciones Detalle")
        {
            DataItemTableView = SORTING("Cod. Colegio", "Grupo de Negocio", "Cod. Grado", "Cod. Turno", "Cod. Promotor", "Cod. Producto");

            trigger OnAfterGetRecord()
            var
                recHisAdop: Record "Historico Adopciones";
            begin


                recHisAdop.Init;
                recHisAdop.Campana := codCampaña;
                recHisAdop."Cod. Editorial" := "Cod. Editorial";
                recHisAdop."Cod. Colegio" := "Cod. Colegio";
                recHisAdop."Cod. Nivel" := "Cod. Nivel";
                recHisAdop."Cod. Turno" := "Cod. Turno";
                recHisAdop."Cod. Promotor" := "Cod. Promotor";
                recHisAdop."Cod. producto" := "Cod. Producto";
                recHisAdop."Fecha Adopcion" := "Fecha Adopcion";
                recHisAdop."Cod. Local" := "Cod. Local";
                recHisAdop."Cod. Grado" := "Cod. Grado";
                recHisAdop.Seccion := Seccion;
                recHisAdop."Cod. Equiv. Santillana" := "Cod. Equiv. Santillana";
                recHisAdop."Nombre Libro" := "Descripcion producto";
                recHisAdop."Cantidad Alumnos" := "Cantidad Alumnos";
                recHisAdop."% Dto. Padres de familia" := "% Dto. Padres";
                recHisAdop."% Dto. Colegio" := "% Dto. Colegio";
                recHisAdop."% Dto. Docente" := "% Dto. Docente";
                recHisAdop."% Dto. Feria Padres de familia" := "% Dto. Feria Padres";
                recHisAdop."% Dto. Feria Colegio" := "% Dto. Feria Colegio";
                recHisAdop."Cod. Motivo perdida adopcion" := "Cod. Motivo perdida adopcion";
                //recHisAdop."Cod. Libro Equivalente" := ;
                //recHisAdop."Adopciones Camp. Anterior" := ;
                recHisAdop.Adopcion := Adopcion;
                recHisAdop."Adopcion anterior" := "Adopcion anterior";
                //fes mig recHisAdop.Santillana := Santillana;
                recHisAdop."Ano adopcion" := "Ano adopcion";
                recHisAdop."Descripcion producto" := "Descripcion producto";
                recHisAdop.Usuario := Usuario;
                recHisAdop."Linea de negocio" := "Linea de negocio";
                recHisAdop.Familia := Familia;
                //fes mig recHisAdop."Sub Familia" := "Sub Familia";
                recHisAdop.Serie := Serie;
                recHisAdop."Fecha Ult. Modificacion" := "Fecha Ult. Modificacion";
                recHisAdop."Adopcion Real" := "Adopcion Real";
                recHisAdop."Motivo perdida adopcion" := "Motivo perdida adopcion";
                recHisAdop."Cod. Producto Editora" := "Cod. Producto Editora";
                recHisAdop."Nombre Producto Editora" := "Nombre Producto Editora";
                recHisAdop."Grupo de Negocio" := "Grupo de Negocio";
                recHisAdop."Carga horaria" := "Carga horaria";
                recHisAdop."Tipo Ingles" := "Tipo Ingles";
                recHisAdop.Materia := Materia;
                //fes mig recHisAdop."Mes de Lectura" := "Mes de Lectura";
                recHisAdop."Descripcion Equiv. Santillana" := "Descripcion Equiv. Santillana";
                recHisAdop."Nombre Editorial" := "Nombre Editorial";
                recHisAdop."Nombre Colegio" := "Nombre Colegio";
                recHisAdop."Descripcion Nivel" := "Descripcion Nivel";
                recHisAdop."Descripcion Grado" := "Descripcion Grado";
                recHisAdop."Nombre Promotor" := "Nombre Promotor";
                recHisAdop.Insert;
            end;

            trigger OnPostDataItem()
            begin
                DeleteAll;
            end;
        }
        dataitem(ColNiveles; "Colegio - Nivel")
        {
            DataItemTableView = SORTING("Cod. Colegio", "Cod. Nivel", Turno, Ruta);

            trigger OnAfterGetRecord()
            var
                recHistNivel: Record "Historico Colegio - Nivel";
            begin
                recHistNivel.Init;
                recHistNivel.TransferFields(ColNiveles);
                recHistNivel.Campana := codCampaña;
                recHistNivel.Insert;
            end;

            trigger OnPostDataItem()
            begin
                DeleteAll;
            end;
        }
        dataitem(PromRutas; "Promotor - Rutas")
        {
            DataItemTableView = SORTING("Cod. Promotor", "Cod. Ruta");

            trigger OnPreDataItem()
            begin
                DeleteAll;
            end;
        }
        dataitem(PromPptoVtas; "Promotor - Ppto Vtas")
        {
            DataItemTableView = SORTING("Cod. Promotor", "Cod. Producto");

            trigger OnPreDataItem()
            begin
                DeleteAll;
            end;
        }
        dataitem(PromColegios; "Promotor - Lista de Colegios")
        {
            DataItemTableView = SORTING("Cod. Promotor", "Cod. Colegio");

            trigger OnPreDataItem()
            begin
                DeleteAll;
            end;
        }
        dataitem("Colegio - Docentes"; "Colegio - Docentes")
        {

            trigger OnAfterGetRecord()
            var
                recHistColDoc: Record "Hist. Colegio - Docentes";
            begin
                recHistColDoc.Init;
                recHistColDoc.TransferFields("Colegio - Docentes");
                recHistColDoc.Campana := codCampaña;
                recHistColDoc.Insert;

                "Colegio - Docentes"."Cod. Nivel" := '';
                "Colegio - Docentes"."Descripcion Nivel" := '';
                "Colegio - Docentes"."Cod. Promotor" := '';
                "Colegio - Docentes".Modify;
            end;
        }
        dataitem("Colegio - Adopciones Cab"; "Colegio - Adopciones Cab")
        {

            trigger OnAfterGetRecord()
            var
                recHistColAdop: Record "Hist. Colegio - Adopciones Cab";
            begin
                recHistColAdop.Init;
                recHistColAdop.TransferFields("Colegio - Adopciones Cab");
                recHistColAdop.Campana := codCampaña;
                recHistColAdop.Insert;
            end;

            trigger OnPostDataItem()
            begin
                DeleteAll;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Opciones)
                {
                    Caption = 'Opciones';
                    field("codCampaña"; codCampaña)
                    {
                    ApplicationArea = All;
                        Caption = 'Campaña a cerrar';
                        TableRelation = Campaign;
                    }
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

    trigger OnPostReport()
    begin
        Message(Text002, codCampaña);
    end;

    trigger OnPreReport()
    begin
        if codCampaña = '' then
            Error(Text001);
    end;

    var
        "codCampaña": Code[4];
        Text001: Label 'Debe seleccionar la campaña que desea cerrar.';
        Text002: Label 'La campaña %1 ha sido cerrada.';


    procedure "ControlCampañaCerrada"()
    begin
    end;
}

