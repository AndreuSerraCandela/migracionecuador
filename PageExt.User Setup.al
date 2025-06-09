pageextension 50007 pageextension50007 extends "User Setup"
{
    layout
    {
        modify(Email)
        {
            Visible = false;
        }
        addafter("User ID")
        {
            field("E-Mail"; rec."E-Mail")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Register Time")
        {
            field("Anula Comprobante Retencion"; rec."Anula Comprobante Retencion")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Purchase Resp. Ctr. Filter")
        {
            field("Ingresa Diario Caja Chica"; rec."Ingresa Diario Caja Chica")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Registra Diario Caja Chica"; rec."Registra Diario Caja Chica")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Aprueba Cantidades"; rec."Aprueba Cantidades")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Aprueba Cantidades Transf."; rec."Aprueba Cantidades Transf.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Desbloquea Clientes"; rec."Desbloquea Clientes")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Desbloquea Proveedores"; rec."Desbloquea Proveedores")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Desbloquea Productos"; rec."Desbloquea Productos")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Desbloquea Activos Fijos"; rec."Desbloquea Activos Fijos")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Modifica ID Retención Banco"; rec."Modifica ID Retención Banco")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        addafter("Time Sheet Admin.")
        {
            field("Modifica Precio Venta"; rec."Modifica Precio Venta")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Puerto Impresora Etiquetas"; rec."Puerto Impresora Etiquetas")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo Conexion Impr. Etiquetas"; rec."Tipo Conexion Impr. Etiquetas")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Nombre Maquina Etiqueta Caja"; rec."Nombre Maquina Etiqueta Caja")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Nombre Impresora. Etiq. Caja"; rec."Nombre Impresora. Etiq. Caja")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Usuario Movilidad"; rec."Usuario Movilidad")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Modifica Descuento Venta"; rec."Modifica Descuento Venta")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Modifica Fecha Pedidos Venta"; rec."Modifica Fecha Pedidos Venta")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Mod. Fecha Recep. Fact. Vta."; rec."Mod. Fecha Recep. Fact. Vta.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Modifica Desc. prod. Lin. Vta."; rec."Modifica Desc. prod. Lin. Vta.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Borra Devoluciones venta"; rec."Borra Devoluciones venta")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Activa/Inactiva Maestros"; rec."Activa/Inactiva Maestros")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Editar Prod. MdM Parcial"; rec."Editar Prod. MdM Parcial")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Editar Prod. MdM Total"; rec."Editar Prod. MdM Total")
            {
                ApplicationArea = Basic, Suite;
                Editable = true;
            }
            field("Arranca Cola Proyecto MdM"; rec."Arranca Cola Proyecto MdM")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'El usuario provocará el arranque de la cola de proyectos MdM de forma automática';
            }
            field("Fecha de Bloqueo Cliente"; rec."Fecha de Bloqueo Cliente")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Filtro Grupo Negocio"; rec."Filtro Grupo Negocio")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}

