codeunit 76047 "Limpiar Conf POS - PELIGRO"
{

    trigger OnRun()
    var
        rTiendas: Record Tiendas;
        rCajeros: Record Cajeros;
        rGruposCaj: Record "Grupos Cajeros";
        rUsuarios: Record "Usuarios TPV";
        rBancos: Record "Bancos tienda";
        rConf: Record "Configuracion General DsPOS";
        rConf2: Record "Configuracion TPV";
        rMenus: Record "Menu ventas TPV";
        rClientes: Record "Clinetes TPV";
        rBotones: Record Botones;
        rFpago: Record "Formas de Pago";
        rFpago2: Record "Formas de Pago TPV";
        rTarj: Record "Tipos de Tarjeta";
    begin

        rTiendas.DeleteAll(false);
        rCajeros.DeleteAll(false);
        rGruposCaj.DeleteAll(false);
        rUsuarios.DeleteAll(false);
        rBancos.DeleteAll(false);
        rConf.DeleteAll(false);
        rConf2.DeleteAll(false);
        rMenus.DeleteAll(false);
        rClientes.DeleteAll(false);
        rBotones.DeleteAll(false);
        rFpago.DeleteAll(false);
        rFpago2.DeleteAll(false);
        rTarj.DeleteAll(false);
        Message('ok');
    end;
}

