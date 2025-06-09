page 55021 "Captura Adopciones APS"
{
    ApplicationArea = all;

    Caption = 'Get Adoptions APS';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Colegio - Adopciones Detalle";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field("Cod. Producto"; rec."Cod. Producto")
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
                    Editable = false;
                }
                field("Nombre Editorial"; rec."Nombre Editorial")
                {
                    Editable = false;
                }
                field("Descripcion producto"; rec."Descripcion producto")
                {
                    Editable = false;
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                    Editable = false;
                }
                field("Descripcion Nivel"; rec."Descripcion Nivel")
                {
                    Editable = false;
                }
                field("Descripcion Grado"; rec."Descripcion Grado")
                {
                    Editable = false;
                }
                field("Fecha Adopcion"; rec."Fecha Adopcion")
                {
                }
                field("Cantidad Alumnos"; rec."Cantidad Alumnos")
                {
                }
                field("% Dto. Padres"; rec."% Dto. Padres")
                {
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
                field("Capex amortizado"; rec."Capex amortizado")
                {
                }
                field("Anos convenio"; rec."Anos convenio")
                {
                }
                field("Cod. Motivo perdida adopcion"; rec."Cod. Motivo perdida adopcion")
                {
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                    Editable = false;
                }
                field(Adopcion; rec.Adopcion)
                {
                }
                field("Adopcion anterior"; rec."Adopcion anterior")
                {
                }
                field(Santillana; rec.Santillana)
                {
                }
                field("Ano adopcion"; rec."Ano adopcion")
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
                field(Serie; rec.Serie)
                {
                }
                field("Adopcion Real"; rec."Adopcion Real")
                {
                }
                field("Motivo perdida adopcion"; rec."Motivo perdida adopcion")
                {
                }
                field("Cod. Producto Editora"; rec."Cod. Producto Editora")
                {
                }
                field("Nombre Producto Editora"; rec."Nombre Producto Editora")
                {
                }
                field("Grupo de Negocio"; rec."Grupo de Negocio")
                {
                }
                field("Carga horaria"; rec."Carga horaria")
                {
                }
                field("Tipo Ingles"; rec."Tipo Ingles")
                {
                }
                field(Materia; rec.Materia)
                {
                }
                field("Mes de Lectura"; rec."Mes de Lectura")
                {
                    Visible = false;
                }
                field(Inventory; rec.Inventory)
                {
                }
                field("PVP Campaña"; rec."PVP Campaña")
                {
                }
                field("Unit Price"; rec."Unit Price")
                {
                }
                field("Item - Item Category Code"; rec."Item - Item Category Code")
                {
                    Editable = false;
                }
                field("Sales Price - Unit Price"; rec."Sales Price - Unit Price")
                {
                }
                field("Item - Product Group Code"; rec."Item - Product Group Code")
                {
                    Editable = false;
                }
                field("Nombre De Canal 2"; rec."Nombre De Canal 2")
                {
                }
                field("Item - Grado"; rec."Item - Grado")
                {
                    Editable = false;
                }
                field("% Dto. Donacion Plantel"; rec."% Dto. Donacion Plantel")
                {
                }
                field("Infraestructura para PLANTEL"; rec."Infraestructura para PLANTEL")
                {
                }
                field("Becas PLANTEL"; rec."Becas PLANTEL")
                {
                }
                field("Equipos PLANTEL"; rec."Equipos PLANTEL")
                {
                }
                field("Capacitación PLANTEL"; rec."Capacitación PLANTEL")
                {
                }
                field("Descuento Total"; rec."Descuento Total")
                {
                }
                field("Codigo Canal Ventas"; rec."Codigo Canal Ventas")
                {
                }
                field("Nombre Canal"; rec."Nombre Canal")
                {
                }
                field("Fecha de lectura"; rec."Fecha de lectura")
                {
                }
                field(Linea; rec.Linea)
                {
                }
                field("Canal venta 3"; rec."Canal venta 3")
                {
                }
                field("Tipo Canal"; rec."Tipo Canal")
                {
                }
                field("Tipo verificacion"; rec."Tipo verificacion")
                {
                }
            }
        }
    }

    actions
    {
    }
}

