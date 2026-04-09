package cn.iocoder.aios.module.mes.dal.mysql.wm.salesnotice;

import cn.iocoder.aios.framework.common.pojo.PageResult;
import cn.iocoder.aios.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.aios.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.aios.module.mes.controller.admin.wm.salesnotice.vo.MesWmSalesNoticePageReqVO;
import cn.iocoder.aios.module.mes.dal.dataobject.wm.salesnotice.MesWmSalesNoticeDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * MES 发货通知单 Mapper
 */
@Mapper
public interface MesWmSalesNoticeMapper extends BaseMapperX<MesWmSalesNoticeDO> {

    default PageResult<MesWmSalesNoticeDO> selectPage(MesWmSalesNoticePageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<MesWmSalesNoticeDO>()
                .likeIfPresent(MesWmSalesNoticeDO::getNoticeCode, reqVO.getNoticeCode())
                .likeIfPresent(MesWmSalesNoticeDO::getNoticeName, reqVO.getNoticeName())
                .likeIfPresent(MesWmSalesNoticeDO::getSalesOrderCode, reqVO.getSalesOrderCode())
                .eqIfPresent(MesWmSalesNoticeDO::getClientId, reqVO.getClientId())
                .orderByDesc(MesWmSalesNoticeDO::getId));
    }

    default MesWmSalesNoticeDO selectByNoticeCode(String noticeCode) {
        return selectOne(MesWmSalesNoticeDO::getNoticeCode, noticeCode);
    }

    default List<MesWmSalesNoticeDO> selectListByStatus(Integer status) {
        return selectList(MesWmSalesNoticeDO::getStatus, status);
    }

}
