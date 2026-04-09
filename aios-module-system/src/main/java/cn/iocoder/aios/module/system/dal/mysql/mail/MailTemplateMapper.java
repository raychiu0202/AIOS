package cn.iocoder.aios.module.system.dal.mysql.mail;

import cn.iocoder.aios.framework.common.pojo.PageResult;
import cn.iocoder.aios.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.aios.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.aios.module.system.controller.admin.mail.vo.template.MailTemplatePageReqVO;
import cn.iocoder.aios.module.system.dal.dataobject.mail.MailTemplateDO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MailTemplateMapper extends BaseMapperX<MailTemplateDO> {

    default PageResult<MailTemplateDO> selectPage(MailTemplatePageReqVO pageReqVO){
        return selectPage(pageReqVO , new LambdaQueryWrapperX<MailTemplateDO>()
                .eqIfPresent(MailTemplateDO::getStatus, pageReqVO.getStatus())
                .likeIfPresent(MailTemplateDO::getCode, pageReqVO.getCode())
                .likeIfPresent(MailTemplateDO::getName, pageReqVO.getName())
                .eqIfPresent(MailTemplateDO::getAccountId, pageReqVO.getAccountId())
                .betweenIfPresent(MailTemplateDO::getCreateTime, pageReqVO.getCreateTime())
                .orderByDesc(MailTemplateDO::getId));
    }

    default Long selectCountByAccountId(Long accountId) {
        return selectCount(MailTemplateDO::getAccountId, accountId);
    }

    default MailTemplateDO selectByCode(String code) {
        return selectOne(MailTemplateDO::getCode, code);
    }

}
