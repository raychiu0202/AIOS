package cn.iocoder.aios.module.mes.dal.mysql.wm.arrivalnotice;

import cn.iocoder.aios.framework.common.pojo.PageResult;
import cn.iocoder.aios.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.aios.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.aios.module.mes.controller.admin.wm.arrivalnotice.vo.MesWmArrivalNoticePageReqVO;
import cn.iocoder.aios.module.mes.dal.dataobject.wm.arrivalnotice.MesWmArrivalNoticeDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * MES 到货通知单 Mapper
 */
@Mapper
public interface MesWmArrivalNoticeMapper extends BaseMapperX<MesWmArrivalNoticeDO> {

    default PageResult<MesWmArrivalNoticeDO> selectPage(MesWmArrivalNoticePageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<MesWmArrivalNoticeDO>()
                .likeIfPresent(MesWmArrivalNoticeDO::getCode, reqVO.getCode())
                .likeIfPresent(MesWmArrivalNoticeDO::getName, reqVO.getName())
                .likeIfPresent(MesWmArrivalNoticeDO::getPurchaseOrderCode, reqVO.getPurchaseOrderCode())
                .eqIfPresent(MesWmArrivalNoticeDO::getVendorId, reqVO.getVendorId())
                .betweenIfPresent(MesWmArrivalNoticeDO::getArrivalDate, reqVO.getArrivalDate())
                .eqIfPresent(MesWmArrivalNoticeDO::getStatus, reqVO.getStatus())
                .orderByDesc(MesWmArrivalNoticeDO::getId));
    }

    default MesWmArrivalNoticeDO selectByCode(String code) {
        return selectOne(MesWmArrivalNoticeDO::getCode, code);
    }

    default List<MesWmArrivalNoticeDO> selectListByStatus(Integer status) {
        return selectList(MesWmArrivalNoticeDO::getStatus, status);
    }

    default Long selectCountByVendorId(Long vendorId) {
        return selectCount(MesWmArrivalNoticeDO::getVendorId, vendorId);
    }

}
