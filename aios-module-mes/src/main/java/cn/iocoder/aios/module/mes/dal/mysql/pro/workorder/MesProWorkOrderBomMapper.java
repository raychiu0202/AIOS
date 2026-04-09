package cn.iocoder.aios.module.mes.dal.mysql.pro.workorder;

import cn.iocoder.aios.framework.common.pojo.PageResult;
import cn.iocoder.aios.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.aios.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.aios.module.mes.controller.admin.pro.workorder.vo.bom.MesProWorkOrderBomPageReqVO;
import cn.iocoder.aios.module.mes.dal.dataobject.pro.workorder.MesProWorkOrderBomDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * MES 生产工单 BOM Mapper
 *
 * @author 芋道源码
 */
@Mapper
public interface MesProWorkOrderBomMapper extends BaseMapperX<MesProWorkOrderBomDO> {

    default PageResult<MesProWorkOrderBomDO> selectPage(MesProWorkOrderBomPageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<MesProWorkOrderBomDO>()
                .eqIfPresent(MesProWorkOrderBomDO::getWorkOrderId, reqVO.getWorkOrderId())
                .orderByDesc(MesProWorkOrderBomDO::getId));
    }

    default List<MesProWorkOrderBomDO> selectListByWorkOrderId(Long workOrderId) {
        return selectList(MesProWorkOrderBomDO::getWorkOrderId, workOrderId);
    }

    default void deleteByWorkOrderId(Long workOrderId) {
        delete(MesProWorkOrderBomDO::getWorkOrderId, workOrderId);
    }

}
