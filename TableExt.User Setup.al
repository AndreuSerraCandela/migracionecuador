tableextension 50170 tableextension50170 extends "User Setup"
{
    fields
    {
        field(50000; "Permite modificar Cupon"; Boolean)
        {
            Caption = 'Allow modify Coupon';
            DataClassification = ToBeClassified;
        }
        field(50001; "Permite Reimprimir Historicos"; Boolean)
        {
            Caption = 'Allow Print Posted Documents';
            DataClassification = ToBeClassified;
        }
        field(50002; "Modifica Fecha Pedidos Venta"; Boolean)
        {
            Caption = 'Modify date in Sales Order';
            DataClassification = ToBeClassified;
        }
        field(50003; "Permite Modificar NIT en Hist."; Boolean)
        {
            Caption = 'Allow to modify VAT in Posted Inv.';
            DataClassification = ToBeClassified;
        }
        field(50004; "Permite Anular Folios IFacere"; Boolean)
        {
            Caption = 'Allow to void Folios at IFacere';
            DataClassification = ToBeClassified;
        }
        field(50005; "Modifica Precio Venta"; Boolean)
        {
            Caption = 'Modify Sales Price';
            DataClassification = ToBeClassified;
        }
        field(50006; "Modifica Descuento Venta"; Boolean)
        {
            Caption = 'Modify Sales Discount';
            DataClassification = ToBeClassified;
        }
        field(50007; "Desbloquea Clientes"; Boolean)
        {
            Caption = 'Unlock Customers';
            DataClassification = ToBeClassified;
            Description = 'CampReq1.01';
        }
        field(50008; "Modifica Desc. prod. Lin. Vta."; Boolean)
        {
            Caption = 'Modify Item Desc. in Sales Line';
            DataClassification = ToBeClassified;
        }
        field(50009; "Usuario Movilidad"; Boolean)
        {
            Caption = 'Mobile user';
            DataClassification = ToBeClassified;
        }
        field(50010; "Ubicacion Impresion Etiqueta"; Text[250])
        {
            Caption = 'Label print path';
            DataClassification = ToBeClassified;
        }
        field(50011; "Mod. Fecha Recep. Fact. Vta."; Boolean)
        {
            Caption = 'Modify Reception date in Sales Invoice';
            DataClassification = ToBeClassified;
        }
        field(50012; "Puerto Imp. Fiscal"; Text[30])
        {
            Caption = 'Fiscal Printer Port';
            DataClassification = ToBeClassified;
            Description = 'Santillana Panama';
        }
        field(50013; "Velocidad Imp. Fiscal"; Integer)
        {
            Caption = 'Fiscal Printer Port Speed';
            DataClassification = ToBeClassified;
            Description = 'Santillana Panama';
        }
        field(50014; "Aprueba Cantidades"; Boolean)
        {
            Caption = 'Approve Sales Qty.';
            DataClassification = ToBeClassified;
        }
        field(50015; "Aprueba Orden de compra"; Boolean)
        {
            Caption = 'Purchase Order Approval';
            DataClassification = ToBeClassified;
        }
        field(50016; "Desbloquea Proveedores"; Boolean)
        {
            Caption = 'Unlok Vendors';
            DataClassification = ToBeClassified;
            Description = 'CampReq1.01';
        }
        field(50017; "Puerto Impresora Etiquetas"; Text[30])
        {
            Caption = 'Labels Printer Port';
            DataClassification = ToBeClassified;
        }
        field(50018; "Tipo Conexion Impr. Etiquetas"; Option)
        {
            Caption = 'Label Printer Connection Type';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Local","Terminal Service";
        }
        field(50019; "Desbloquea Productos"; Boolean)
        {
            Caption = 'Unlock Items';
            DataClassification = ToBeClassified;
            Description = 'Peru,CampReq1.01';
        }
        field(50021; "Aprueba Cantidades Transf."; Boolean)
        {
            Caption = 'Approve Transfer Qty.';
            DataClassification = ToBeClassified;
            Description = 'Peru';
        }
        field(50022; "Anula Hoja de Ruta"; Boolean)
        {
            Caption = 'Void Route Guide';
            DataClassification = ToBeClassified;
        }
        field(50023; "Nombre Maquina Etiqueta Caja"; Text[70])
        {
            Caption = 'Box Tag Machine Name';
            DataClassification = ToBeClassified;
        }
        field(50024; "Nombre Impresora. Etiq. Caja"; Text[30])
        {
            Caption = 'Tag Box Printer Shared Name';
            DataClassification = ToBeClassified;
        }
        field(50025; "Anula Comprobante Retencion"; Boolean)
        {
            Caption = 'Void Retention Correlative';
            DataClassification = ToBeClassified;
        }
        field(50026; "Desbloquea Activos Fijos"; Boolean)
        {
            Caption = 'Ublock Fixed Assent';
            DataClassification = ToBeClassified;
            Description = 'CampReq1.01';
        }
        field(50027; "Filtro Grupo Negocio"; Boolean)
        {
            Caption = 'Business Group Filter';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-2524';
        }
        field(50030; "Desbloquea Contactos"; Boolean)
        {
            Caption = 'Desbloquea Contactos';
            DataClassification = ToBeClassified;
            Description = 'CampReq1.01';
        }
        field(50031; "Desbloquea Proyectos"; Boolean)
        {
            Caption = 'Unblock Jobs';
            DataClassification = ToBeClassified;
            Description = 'CampReq1.01';
        }
        field(50032; "Desbloquea Empleados"; Boolean)
        {
            Caption = 'Unblock Employees';
            DataClassification = ToBeClassified;
            Description = 'CampReq1.01';
        }
        field(55000; "Modifica ID Retención Banco"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55001; "Ingresa Diario Caja Chica"; Boolean)
        {
            Caption = 'Create Petty Cash Journal';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55002; "Registra Diario Caja Chica"; Boolean)
        {
            Caption = 'Post Petty Cash Journal';
            DataClassification = ToBeClassified;
            Description = 'Ecuador';
        }
        field(55003; "Borra Devoluciones venta"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '#20920 ClasDev';
        }
        field(56001; "Activa/Inactiva Maestros"; Boolean)
        {
            Caption = 'Active/Inactive Files';
            DataClassification = ToBeClassified;
            Description = '001';
        }
        field(75000; "Editar Prod. MdM Parcial"; Boolean)
        {
            Caption = 'Editar Prod. MdM';
            DataClassification = ToBeClassified;
            Description = 'MdM';
        }
        field(75001; "Editar Prod. MdM Total"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'MdM';
        }
        field(75002; "Arranca Cola Proyecto MdM"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'MdM';
        }
        field(75003; "Fecha de Bloqueo Cliente"; Boolean)
        {
            Caption = 'Fecha de Bloqueo Cliente';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-1641';
        }
    }
}

